/*
 *  Multi Marker Pose Estimation using ARToolkit
 *  Copyright (C) 2010, CCNY Robotics Lab
 *  Ivan Dryanovski <ivan.dryanovski@gmail.com>
 *  William Morris <morris@ee.ccny.cuny.edu>
 *  Gautier Dumonteil <gautier.dumonteil@gmail.com>
 *  http://robotics.ccny.cuny.edu
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

// system includes
#include <usc_utilities/assert.h>
#include <usc_utilities/param_server.h>

#include <angles/angles.h>

// local includes
#include <ar_target/ar_multiple_single.h>
#include <ar_target/object.h>

namespace ar_target
{

ARMultipleSinglePublisher::ARMultipleSinglePublisher(ros::NodeHandle& node_handle) :
  ARBase(node_handle)
{
  // subscribe
  ROS_INFO ("ARMultipleSinglePublisher subscribing to info topic >%s<.", camera_info_topic_.c_str());
  camera_info_subcriber_ = node_handle_.subscribe(camera_info_topic_, 1, &ARMultipleSinglePublisher::camInfoCallback, this);

  // advertise
  ar_marker_publisher_ = node_handle_.advertise<ar_target::ARMarkers> ("ar_target_marker", 0);
  if (publish_visual_markers_)
  {
    rviz_marker_pub_ = node_handle_.advertise<visualization_msgs::Marker> ("visualization_marker", 0);
  }
  ar_marker_pub_ = node_handle_.advertise<ar_target::ARMarkers> ("ar_target_marker", 0);
}

void ARMultipleSinglePublisher::camInfoCallback(const sensor_msgs::CameraInfoConstPtr & cam_info)
{
  if (!get_camera_info_)
  {
    cam_info_ = (*cam_info);

    cam_param_.xsize = cam_info_.width;
    cam_param_.ysize = cam_info_.height;

    cam_param_.mat[0][0] = cam_info_.P[0];
    cam_param_.mat[1][0] = cam_info_.P[4];
    cam_param_.mat[2][0] = cam_info_.P[8];
    cam_param_.mat[0][1] = cam_info_.P[1];
    cam_param_.mat[1][1] = cam_info_.P[5];
    cam_param_.mat[2][1] = cam_info_.P[9];
    cam_param_.mat[0][2] = cam_info_.P[2];
    cam_param_.mat[1][2] = cam_info_.P[6];
    cam_param_.mat[2][2] = cam_info_.P[10];
    cam_param_.mat[0][3] = cam_info_.P[3];
    cam_param_.mat[1][3] = cam_info_.P[7];
    cam_param_.mat[2][3] = cam_info_.P[11];

    cam_param_.dist_factor[0] = cam_info_.K[2]; // x0 = cX from openCV calibration
    cam_param_.dist_factor[1] = cam_info_.K[5]; // y0 = cY from openCV calibration
    // cam_param_.dist_factor[2] = -100 * cam_info_.D[0]; // f = -100*k1 from CV. Note, we had to do mm^2 to m^2, hence 10^8->10^2
    cam_param_.dist_factor[2] = 0.0; // f = -100*k1 from CV. Note, we had to do mm^2 to m^2, hence 10^8->10^2
    cam_param_.dist_factor[3] = 1.0; // scale factor, should probably be >1, but who cares...

    arInit();

    ROS_INFO ("ARMultipleSinglePublisher subscribing to image topic >%s<.", camera_image_topic_.c_str());
    cam_sub_ = it_.subscribe(camera_image_topic_, 1, &ARMultipleSinglePublisher::getTransformationCallback, this);
    get_camera_info_ = true;
  }
}

void ARMultipleSinglePublisher::arInit()
{
  arInitCparam(&cam_param_);
  ROS_INFO("Camera parameters for ARMultipleSinglePublisher are:");
  arParamDisp(&cam_param_);

  // load in the object data - trained markers and associated bitmap files
  if ((object_ = ar_object::read_ObjData(pattern_filename_, &objectnum_)) == NULL)
  {
    ROS_ASSERT_MSG(false, "Could not load configurations for ARMultipleSinglePublisher.");
  }
  ROS_INFO("Read >%i< objects from file.", objectnum_);

  size_ = cvSize(cam_param_.xsize, cam_param_.ysize);
  capture_ = cvCreateImage(size_, IPL_DEPTH_8U, 4);
}

void ARMultipleSinglePublisher::getTransformationCallback(const sensor_msgs::ImageConstPtr & image_msg)
{

  /* Get the image from ROSTOPIC
   * NOTE: the dataPtr format is BGR because the ARToolKit library was
   * build with V4L, dataPtr format change according to the
   * ARToolKit configure option (see config.h).*/
  try
  {
    capture_ = bridge_.imgMsgToCv(image_msg, "bgr8");
  }
  catch (sensor_msgs::CvBridgeException & e)
  {
    ROS_ERROR ("Could not convert from '%s' to 'bgr8'.", image_msg->encoding.c_str ());
  }
  //cvConvertImage(capture,capture,CV_CVTIMG_FLIP);
  ARUint8* data_ptr = (ARUint8 *)capture_->imageData;

  // detect the markers in the video frame
  if (arDetectMarker(data_ptr, threshold_, &marker_info_, &num_detected_marker_) < 0)
  {
    argCleanup();
    ROS_BREAK ();
  }

  ar_markers_.markers.clear();
  ar_markers_.header.frame_id = camera_frame_;
  ar_markers_.header.stamp = image_msg->header.stamp;

  // check for known patterns
  int index;
  for (int i = 0; i < objectnum_; i++)
  {
    index = -1;
    for (int j = 0; j < num_detected_marker_; j++)
    {
      if (object_[i].id == marker_info_[j].id)
      {
        if (index == -1)
        {
          index = j;
        }
        else // make sure you have the best pattern (highest confidence factor)
        {
          if (marker_info_[index].cf < marker_info_[j].cf)
          {
            index = j;
          }
        }
      }
    }
    if (index == -1)
    {
      object_[i].visible = 0;
      continue;
    }

    // calculate the transform for each marker
    if (object_[i].visible == 0)
    {
      arGetTransMat(&marker_info_[index], object_[i].marker_center, object_[i].marker_width, object_[i].trans);
    }
    else
    {
      arGetTransMatCont(&marker_info_[index], object_[i].trans, object_[i].marker_center, object_[i].marker_width, object_[i].trans);
    }
    object_[i].visible = 1;

    double ar_quat[4], ar_pos[3];
    // arUtilMatInv (object[i].trans, cam_trans);
    arUtilMat2QuatPos(object_[i].trans, ar_quat, ar_pos);
    // convert to ROS frame
    tf::Quaternion rotation(-ar_quat[0], -ar_quat[1], -ar_quat[2], ar_quat[3]);
    tf::Vector3 origin(ar_pos[0] * AR_TO_ROS, ar_pos[1] * AR_TO_ROS, ar_pos[2] * AR_TO_ROS);
    tf::Transform transform(rotation, origin);

    // add the marker
    addMarker(index, transform);

    // publish transform between camera and marker
    if (publish_tf_)
    {
      std::string frame_name = marker_frame_ + boost::lexical_cast<std::string>(marker_info_[index].id);
      tf::StampedTransform cam_to_marker(transform, image_msg->header.stamp, image_msg->header.frame_id, frame_name);
      tf_broadcaster_.sendTransform(cam_to_marker);
    }

    // publish visual marker
    publishMarker(index, transform, image_msg->header.stamp);

  }
  ar_marker_pub_.publish(ar_markers_);
  ROS_DEBUG ("Published ar_multi markers");
}

void ARMultipleSinglePublisher::publishMarker(const int index,
                                              const tf::Transform& transform,
                                              const ros::Time& time_stamp)
{
  const double MARKER_THIKNESS_SCALE = 0.1;
  const double WIDTH = 101.0;
  tf::Vector3 marker_origin(0, 0, (MARKER_THIKNESS_SCALE / (double)2.0) * WIDTH * AR_TO_ROS);
  tf::Transform quaternion(tf::Quaternion::getIdentity(), marker_origin);
  tf::Transform marker_pose = transform * quaternion; // marker pose in the camera frame

  visualization_msgs::Marker rviz_marker;
  tf::poseTFToMsg(marker_pose, rviz_marker.pose);
  rviz_marker.header.frame_id = camera_frame_;
  rviz_marker.header.stamp = time_stamp;
  rviz_marker.id = marker_info_[index].id;

  rviz_marker.scale.x = 1.0 * WIDTH * AR_TO_ROS;
  rviz_marker.scale.y = 1.0 * WIDTH * AR_TO_ROS;
  rviz_marker.scale.z = MARKER_THIKNESS_SCALE * WIDTH * AR_TO_ROS;
  // rviz_marker_.ns.assign(node_handle_.getNamespace());
  rviz_marker.ns.assign(marker_frame_);
  rviz_marker.type = visualization_msgs::Marker::CUBE;
  rviz_marker.action = visualization_msgs::Marker::ADD;
  if(marker_info_[index].cf > 0.81)
  {
    rviz_marker.color.r = marker_red_;
    rviz_marker.color.g = marker_green_;
    rviz_marker.color.b = marker_blue_;
    rviz_marker.color.a = 1.0;
  }
  else
  {
    rviz_marker.color.r = 1.0f;
    rviz_marker.color.g = 0.0f;
    rviz_marker.color.b = 0.0f;
    rviz_marker.color.a = 1.0;
  }
  rviz_marker.lifetime = ros::Duration(0.1);

  rviz_marker_pub_.publish(rviz_marker);
  ROS_DEBUG ("Published visual marker.");
}

void ARMultipleSinglePublisher::addMarker(const int index, const tf::Transform& transform)
{
  ar_target::ARMarker ar_target_marker;
  ar_target_marker.id = marker_info_[index].id;
  ar_target_marker.confidence = marker_info_[index].cf;

  ar_target_marker.quaternion.w = transform.getRotation().getW();
  ar_target_marker.quaternion.x = transform.getRotation().getX();
  ar_target_marker.quaternion.y = transform.getRotation().getY();
  ar_target_marker.quaternion.z = transform.getRotation().getZ();

  for (int i = 0; i < 4; ++i)
  {
    int vertex_index = (marker_info_[index].dir + i) % 4;
    // ROS_INFO("vertex_index = %i.", vertex_index);
    // ar_target_marker.u_corners.push_back(marker_info_[index].vertex[vertex_index][0]);
    // ar_target_marker.v_corners.push_back(marker_info_[index].vertex[vertex_index][1]);
    ar_target_marker.u_corners.push_back(marker_info_[index].vertex[vertex_index][0]);
    ar_target_marker.v_corners.push_back(marker_info_[index].vertex[vertex_index][1]);
  }

  ar_markers_.markers.push_back(ar_target_marker);
}

}

int main(int argc,
         char **argv)
{
  if (argc < 2)
  {
    printf("ERROR: No node name provided. %i\n", argc);
    for (int i = 0; i < argc; i++)
    {
      printf("argv[%i] = %s\n", i, argv[i]);
    }
    return -1;
  }
  printf("Initializing node named: >%s<.\n", argv[1]);
  ros::init(argc, argv, argv[1]);
  ros::NodeHandle node_handle("~");
  ar_target::ARMultipleSinglePublisher ar_multiple_single(node_handle);
  ros::spin();
  return 0;
}

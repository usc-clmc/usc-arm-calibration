/*
 *  Single Marker Pose Estimation using ARToolkit
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
#include <ros/package.h>
#include <usc_utilities/assert.h>
#include <usc_utilities/param_server.h>

#include <angles/angles.h>

// local includes
#include <ar_target/ar_single.h>

namespace ar_target
{

ARSinglePublisher::ARSinglePublisher(ros::NodeHandle node_handle) :
    ARBase(node_handle)
{

  geometry_msgs::Pose marker_offset;
  ROS_VERIFY(usc_utilities::read(node_handle, "marker_offset", marker_offset));

  tf::Vector3 marker_offset_pos(marker_offset.position.x, marker_offset.position.y, marker_offset.position.z);
  tf::Quaternion marker_offset_quat(marker_offset.orientation.x, marker_offset.orientation.y, marker_offset.orientation.z, marker_offset.orientation.w);
  marker_offset_.setOrigin(marker_offset_pos);
  marker_offset_.setRotation(marker_offset_quat);

  ROS_INFO("\tMarker offset position: x=%.2f y=%.2f z=%.2f",
           marker_offset_.getOrigin().getX(), marker_offset_.getOrigin().getY(), marker_offset_.getOrigin().getZ());
  ROS_INFO("\tMarker offset orientation: w=%.2f x=%.2f y=%.2f z=%.2f", marker_offset_.getRotation().getW(),
           marker_offset_.getRotation().getX(), marker_offset_.getRotation().getY(), marker_offset_.getRotation().getZ());

  double rot_x;
  double rot_y;
  double rot_z;
  ROS_VERIFY(usc_utilities::read(node_handle, "rot_x", rot_x));
  ROS_VERIFY(usc_utilities::read(node_handle, "rot_y", rot_y));
  ROS_VERIFY(usc_utilities::read(node_handle, "rot_z", rot_z));
  rot_x = angles::from_degrees(rot_x);
  rot_y = angles::from_degrees(rot_y);
  rot_z = angles::from_degrees(rot_z);
  tf::Quaternion quat;
  quat.setRPY(rot_x, rot_y, rot_z);
  marker_offset_.setRotation(quat);

  node_handle.param("marker_center_x", marker_center_[0], 0.0);
  node_handle.param("marker_center_y", marker_center_[1], 0.0);
  ROS_INFO ("\tMarker Center: (%.1f,%.1f)", marker_center_[0], marker_center_[1]);

  // subscribe
  ROS_INFO ("Subscribing to info topic >%s<.", camera_info_topic_.c_str());
  camera_info_subcriber_ = node_handle_.subscribe(camera_info_topic_, 1, &ARSinglePublisher::camInfoCallback, this);

  // advertise
  ar_marker_publisher_ = node_handle_.advertise<ar_target::ARMarker> ("ar_target_marker", 0);
  if (publish_visual_markers_)
  {
    rviz_marker_pub_ = node_handle_.advertise<visualization_msgs::Marker> ("visualization_marker", 0);
  }
}

ARSinglePublisher::~ARSinglePublisher(void)
{
}

void ARSinglePublisher::camInfoCallback(const sensor_msgs::CameraInfoConstPtr& cam_info)
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
    cam_param_.dist_factor[2] = -100 * cam_info_.D[0]; // f = -100*k1 from CV. Note, we had to do mm^2 to m^2, hence 10^8->10^2
    cam_param_.dist_factor[3] = 1.0; // scale factor, should probably be >1, but who cares...

    arInit();

    ROS_INFO ("Subscribing to image topic >%s<.", camera_image_topic_.c_str());
    cam_sub_ = it_.subscribe(camera_image_topic_, 1, &ARSinglePublisher::getTransformationCallback, this);
    get_camera_info_ = true;
  }
}

void ARSinglePublisher::arInit()
{
  arInitCparam(&cam_param_);

  ROS_INFO ("*** Camera Parameter ***");
  arParamDisp(&cam_param_);

  // load pattern file
  ROS_INFO ("Loading pattern");
  patt_id_ = arLoadPatt(pattern_filename_);
  if (patt_id_ < 0)
  {
    ROS_ERROR ("Pattern file load error: %s", pattern_filename_);
    ROS_BREAK ();
  }

  size_ = cvSize(cam_param_.xsize, cam_param_.ysize);
  capture_ = cvCreateImage(size_, IPL_DEPTH_8U, 4);
}

void ARSinglePublisher::getTransformationCallback(const sensor_msgs::ImageConstPtr& image_msg)
{
  // ROS_INFO("======================================================");
  // ROS_INFO("Callback...");

  ARMarkerInfo *marker_info;
  int marker_num;
  int i, k;

  // Get the image from ROSTOPIC
  // NOTE: the data_ptr format is BGR because the ARToolKit library was
  // build with V4L, data_ptr format change according to the
  // ARToolKit configure option (see config.h).
  try
  {
    capture_ = bridge_.imgMsgToCv(image_msg, "bgr8");
  }
  catch (sensor_msgs::CvBridgeException & e)
  {
    ROS_ERROR("Could not convert from >%s< to 'bgr8'.", image_msg->encoding.c_str ());
    return;
  }

//  const int WIDTH = 640;
//  const int HEIGHT = 480;
//  // declare a destination IplImage object with correct size, depth and channels
//  IplImage *destination = cvCreateImage(cvSize(WIDTH, HEIGHT), capture_->depth, capture_->nChannels);
//  // use cvResize to resize source to a destination image
//  cvResize(capture_, destination);
//  // save image with a name supplied with a second argument
  //  std::string filename = "/tmp/" + marker_frame_ + ".jpg";
  //  cvSaveImage(filename.c_str(), destination);
//  ROS_INFO("BEFORE: Depth = >%i<.", capture_->depth);
//  ROS_INFO("BEFORE: nChannels = >%i<.", capture_->nChannels);
//  ROS_INFO("BEFORE: Width = >%i<.", capture_->width);
//  ROS_INFO("BEFORE: WidthStep = >%i<.", capture_->widthStep);
//  ROS_INFO("BEFORE: Height = >%i<.", capture_->height);
//  ROS_INFO("BEFORE: ImageSize = >%i<.", capture_->imageSize);
//  ROS_INFO("BEFORE: nSize = >%i<.", capture_->nSize);
//  ROS_INFO("BEFORE: dataOrder = >%i<.", capture_->dataOrder);
//  ROS_INFO("BEFORE: origin = >%i<.", capture_->origin);
//  capture_ = destination;
//  // memcpy(capture_->imageData, destination->imageData, destination->imageSize);
//  ROS_INFO("AFTER:  Depth = >%i<.", capture_->depth);
//  ROS_INFO("AFTER:  nChannels = >%i<.", capture_->nChannels);
//  ROS_INFO("AFTER:  Width = >%i<.", capture_->width);
//  ROS_INFO("AFTER:  WidthStep = >%i<.", capture_->widthStep);
//  ROS_INFO("AFTER:  Height = >%i<.", capture_->height);
//  ROS_INFO("AFTER:  ImageSize = >%i<.", capture_->imageSize);
//  ROS_INFO("AFTER:  nSize = >%i<.", capture_->nSize);
//  ROS_INFO("AFTER:  dataOrder = >%i<.", capture_->dataOrder);
//  ROS_INFO("AFTER:  origin = >%i<.", capture_->origin);

  // cvConvertImage(capture_, capture_, CV_CVTIMG_FLIP); //flip image
  ARUint8 *data_ptr = (ARUint8 *)capture_->imageData;

  // detect the markers in the video frame
  if (arDetectMarker(data_ptr, threshold_, &marker_info, &marker_num) < 0)
  {
    ROS_FATAL ("arDetectMarker failed");
    ROS_BREAK (); // FIXME: I don't think this should be fatal... -Bill
  }

  // check for known patterns
  k = -1;
  for (i = 0; i < marker_num; i++)
  {
    if (marker_info[i].id == patt_id_)
    {
      ROS_DEBUG("Found pattern: %d ", patt_id_);

      // make sure you have the best pattern (highest confidence factor)
      if (k == -1)
        k = i;
      else if (marker_info[k].cf < marker_info[i].cf)
        k = i;
    }
  }

  if (k != -1)
  {
    if (!use_history_ || cont_f_ == 0)
    {
      arGetTransMat(&marker_info[k], marker_center_, marker_width_, marker_trans_);
    }
    else
    {
      arGetTransMatCont(&marker_info[k], marker_trans_, marker_center_, marker_width_, marker_trans_);
    }

    cont_f_ = 1;

    // get the transformation between the marker and the real camera
    double arQuat[4], arPos[3];

    // arUtilMatInv (marker_trans_, cam_trans);
    arUtilMat2QuatPos(marker_trans_, arQuat, arPos);

    // error checking
    if(fabs(sqrt(arQuat[0]*arQuat[0] + arQuat[1]*arQuat[1] + arQuat[2]*arQuat[2] + arQuat[3]*arQuat[3]) - 1.0) > 0.0001)
    {
      ROS_WARN("Skipping invalid frame. Computed quaternion is invalid.");
    }
    if(std::isnan(arQuat[0]) || std::isnan(arQuat[1]) || std::isnan(arQuat[2]) || std::isnan(arQuat[3]))
    {
      ROS_WARN("Skipping invalid frame because computed orientation is not a number.");
      return;
    }
    if(std::isinf(arQuat[0]) || std::isinf(arQuat[1]) || std::isinf(arQuat[2]) || std::isinf(arQuat[3]))
    {
      ROS_WARN("Skipping invalid frame because computed orientation is infinite.");
      return;
    }

    // convert to ROS frame

    double quat[4], pos[3];

    pos[0] = arPos[0] * AR_TO_ROS;
    pos[1] = arPos[1] * AR_TO_ROS;
    pos[2] = arPos[2] * AR_TO_ROS;

    quat[0] = -arQuat[0];
    quat[1] = -arQuat[1];
    quat[2] = -arQuat[2];
    quat[3] = arQuat[3];

    ROS_DEBUG("  Pos x: %3.5f  y: %3.5f  z: %3.5f", pos[0], pos[1], pos[2]);
    ROS_DEBUG("  Quat qx: %3.5f qy: %3.5f qz: %3.5f qw: %3.5f", quat[0], quat[1], quat[2], quat[3]);

    // publish the marker

    ar_target_marker_.confidence = marker_info->cf;

    ar_marker_publisher_.publish(ar_target_marker_);
    ROS_DEBUG ("Published ar_single marker");

    // publish transform between camera and marker

    tf::Quaternion rotation(quat[0], quat[1], quat[2], quat[3]);
    tf::Vector3 origin(pos[0], pos[1], pos[2]);
    tf::Transform transform(rotation, origin);

    // TODO: figure out why this happens once in a while...
    if(transform.getOrigin().getZ() < 0.0)
    {
      transform.setOrigin(-transform.getOrigin());
    }

    if (publish_tf_)
    {
      if (reverse_transform_)
      {
        ROS_ASSERT_MSG(false, "Reverse transform is not debugged yet.");
        // tf::StampedTransform marker_to_cam(t.inverse(), image_msg->header.stamp, marker_frame_.c_str(), image_msg->header.frame_id);
        tf::StampedTransform marker_to_cam(transform.inverse(), image_msg->header.stamp, marker_frame_, camera_frame_);
        tf_broadcaster_.sendTransform(marker_to_cam);
      }
      else
      {
        tf::Transform offseted_transform = transform * marker_offset_;
        // tf::StampedTransform cam_to_marker(t, image_msg->header.stamp, image_msg->header.frame_id, marker_frame_.c_str());
        tf::StampedTransform cam_to_marker(offseted_transform, image_msg->header.stamp, camera_frame_, marker_frame_);
        // tf::StampedTransform cam_to_marker(transform, image_msg->header.stamp, camera_frame_, marker_frame_);
        tf_broadcaster_.sendTransform(cam_to_marker);
      }
    }

    // publish visual marker
    publishMarker(transform, image_msg->header.stamp);
  }
  else
  {
    cont_f_ = 0;
    ROS_WARN("Failed to locate marker.");
  }

}

} // end namespace ar_target

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
  ar_target::ARSinglePublisher ar_single(node_handle);
  ros::spin();
  return 0;
}

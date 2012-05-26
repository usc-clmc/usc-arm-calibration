/*********************************************************************
  Computational Learning and Motor Control Lab
  University of Southern California
  Prof. Stefan Schaal 
 *********************************************************************
  \remarks		...
 
  \file		ar_synchronize.cpp

  \author	Peter Pastor
  \date		Sep 4, 2011

 *********************************************************************/

// system includes
#include <visualization_msgs/Marker.h>

#include <usc_utilities/assert.h>
#include <usc_utilities/param_server.h>

#include <Eigen/Eigen>
#include <sensor_msgs/CameraInfo.h>
#include <opencv/cv.h>
#include <angles/angles.h>

// local includes
#include <ar_target/ARMarkers.h>
#include <ar_target/ar_synchronize.h>

namespace ar_target
{

static const std::string MARKER_FRAME = "/ARMarker";
static const double RVIZ_MARKER_LIFETIME = 0.1;

ARSynchronize::ARSynchronize(ros::NodeHandle node_handle) :
    node_handle_(node_handle), got_camera_info_(false), Q_(4, 4, 0.0)
{
  ROS_VERIFY(readTransforms());
  Q_(0,0) = Q_(1,1) = 1.0;
  rviz_marker_pub_ = node_handle_.advertise<visualization_msgs::MarkerArray> ("visualization_marker_array", 10);
  marker_pub_ = node_handle_.advertise<ar_target::ARMarkers3d> ("ar_target_marker_3d", 15);

  marker_index_ = 0;
  marker_array_.reset(new visualization_msgs::MarkerArray());
}

void ARSynchronize::run()
{
  std::string left_camera_info_topic;
  ROS_VERIFY(usc_utilities::read(node_handle_, "left_camera_info_topic", left_camera_info_topic));
  std::string right_camera_info_topic;
  ROS_VERIFY(usc_utilities::read(node_handle_, "right_camera_info_topic", right_camera_info_topic));

  message_filters::Subscriber<sensor_msgs::CameraInfo> left_sub(node_handle_, left_camera_info_topic, 1);
  message_filters::Subscriber<sensor_msgs::CameraInfo> right_sub(node_handle_, right_camera_info_topic, 1);

  message_filters::TimeSynchronizer<sensor_msgs::CameraInfo, sensor_msgs::CameraInfo> sync(left_sub, right_sub, 10);
  sync.registerCallback(boost::bind(&ARSynchronize::camInfoCallback, this, _1, _2));
  while(ros::ok() && !got_camera_info_)
  {
    ros::spinOnce();
  }
  process();
}

void ARSynchronize::process()
{
  message_filters::Subscriber<ar_target::ARMarkers> left_sub(node_handle_, "/ARLeftMultipleSinglePattern/ar_target_marker", 1);
  message_filters::Subscriber<ar_target::ARMarkers> right_sub(node_handle_, "/ARRightMultipleSinglePattern/ar_target_marker", 1);

  message_filters::TimeSynchronizer<ar_target::ARMarkers, ar_target::ARMarkers> sync(left_sub, right_sub, 10);
  sync.registerCallback(boost::bind(&ARSynchronize::markerCallback, this, _1, _2));

  ros::spin();
}

void ARSynchronize::camInfoCallback(const sensor_msgs::CameraInfoConstPtr& left_cam_info,
                                    const sensor_msgs::CameraInfoConstPtr& right_cam_info)
{
  if (!got_camera_info_)
  {
    got_camera_info_ = true;

    left_camera_frame_.assign(left_cam_info->header.frame_id);
    // left_camera_frame_.assign("BUMBLEBEE_LEFT_REAL");
    ROS_INFO("Using frame id >%s<.", left_camera_frame_.c_str());

    left_cam_.fromCameraInfo(left_cam_info);
    right_cam_.fromCameraInfo(right_cam_info);

    ROS_ASSERT( left_cam_.tfFrame() == right_cam_.tfFrame() );
    ROS_ASSERT( left_cam_.fx() == right_cam_.fx() );
    ROS_ASSERT( left_cam_.fy() == right_cam_.fy() );
    ROS_ASSERT( left_cam_.cy() == right_cam_.cy() );

    double baseline = -right_cam_.Tx() / right_cam_.fx();
    double Tx = baseline;
    Q_(3,2) = 1.0 / Tx;
    Q_(0,3) = -right_cam_.cx();
    Q_(1,3) = -right_cam_.cy();
    Q_(2,3) = right_cam_.fx();

    Q_(3,3) = (right_cam_.cx() - left_cam_.cx()) / Tx; // zero when disparities are pre-adjusted
  }
}

bool ARSynchronize::computeDisparity(const std::vector<double>& left,
                                     const std::vector<double>& right,
                                     std::vector<float>& disparity)
{
  ROS_ASSERT(left.size() == right.size());

  disparity.clear();
  for (int i = 0; i < (int)left.size(); ++i)
  {
    // compute disparity in x
    double disp = (left[i] - right[i]);
    disp -= left_cam_.cx() - right_cam_.cx();
    disparity.push_back(disp);
  }
  return true;
}

bool ARSynchronize::readTransforms()
{
  std::string orienation_string;
  std::string position_string;
  marker_static_transforms_.clear();

  ROS_VERIFY(usc_utilities::read(node_handle_, "num_markers", num_markers_));
  ROS_VERIFY(usc_utilities::read(node_handle_, "confidence_threshold", confidence_threshold_));
  for (int i = 0; i < num_markers_; ++i)
  {
    std::vector<double> orientation;
    orienation_string.assign("marker_" + boost::lexical_cast<std::string>(i+1) + "_transform_orientation");
    ROS_VERIFY(usc_utilities::read(node_handle_, orienation_string, orientation));
    ROS_ASSERT(orientation.size() == 3);

    tf::Quaternion quaternion;
    quaternion.setRPY(angles::from_degrees(orientation[0]),
                      angles::from_degrees(orientation[1]),
                      angles::from_degrees(orientation[2]));

    // ROS_ASSERT(orientation.size() == 9);
    // tf::Matrix3x3 rotation_matrix(orientation[0], orientation[1], orientation[2],
    //                             orientation[3], orientation[4], orientation[5],
    //                             orientation[6], orientation[7], orientation[8]);

    std::vector<double> position;
    position_string.assign("marker_" + boost::lexical_cast<std::string>(i+1) + "_transform_position");
    ROS_VERIFY(usc_utilities::read(node_handle_, position_string, position));
    ROS_ASSERT(position.size() == 3);
    tf::Vector3 origin(position[0], position[1], position[2]);

    // tf::Quaternion quaternion;
    // rotation_matrix.getRotation(quaternion);
    tf::Transform transform(quaternion, origin);
    marker_static_transforms_.push_back(transform);
  }
  return true;
}

void ARSynchronize::projectDisparityTo3d(const cv::Point2d& left_uv_rect,
                                         float disparity,
                                         cv::Point3d& xyz) const
{
  // Do the math inline:
  // [X Y Z W]^T = Q * [u v d 1]^T
  // Point = (X/W, Y/W, Z/W)
  // cv::perspectiveTransform could be used but with more overhead.
  double u = left_uv_rect.x, v = left_uv_rect.y;
  cv::Point3d XYZ(u + Q_(0,3), v + Q_(1,3), Q_(2,3));
  double W = Q_(3,2)*disparity + Q_(3,3);
  xyz = XYZ * (1.0/W);
}

void ARSynchronize::markerCallback(const ar_target::ARMarkersConstPtr& left_markers,
                                   const ar_target::ARMarkersConstPtr& right_markers)
{
  // ROS_INFO("Got >%f< >%f<", left_markers->header.stamp.toSec(), right_markers->header.stamp.toSec());

  const double MAX_CORNER_DISTANCE = 0.14;

  ROS_ASSERT(left_markers->header.stamp == right_markers->header.stamp);
  ros::Time markers_stamp = left_markers->header.stamp;

  ar_target::ARMarkers3d markers;
  markers.header.stamp = markers_stamp;

  marker_transforms_.clear();
  marker_confidences_.clear();
  for (int i = 0; i < (int)left_markers->markers.size(); ++i)
  {
    for (int j = 0; j < (int)right_markers->markers.size(); ++j)
    {
      if(left_markers->markers[i].id == right_markers->markers[j].id)
      {
        const int id = left_markers->markers[i].id;
        // ROS_INFO("Got matching id >%i<.", id);
        ROS_ASSERT_MSG(left_markers->markers[i].u_corners.size() == 4,
                       "Number of left x marker corner image pixels >%i< should be 4.",
                       (int)left_markers->markers[i].u_corners.size());
        ROS_ASSERT_MSG(left_markers->markers[i].v_corners.size() == 4,
                       "Number of left y marker corner image pixels >%i< should be 4.",
                       (int)left_markers->markers[i].v_corners.size());
        ROS_ASSERT_MSG(right_markers->markers[j].u_corners.size() == 4,
                       "Number of right x marker corner image pixels >%i< should be 4.",
                       (int)right_markers->markers[j].u_corners.size());
        ROS_ASSERT_MSG(right_markers->markers[j].v_corners.size() == 4,
                       "Number of right y marker corner image pixels >%i< should be 4.",
                       (int)right_markers->markers[j].v_corners.size());

        std::vector<float> disparity;
        ROS_VERIFY(computeDisparity(left_markers->markers[i].u_corners,
                                    right_markers->markers[j].u_corners,
                                    disparity));
        ROS_ASSERT(disparity.size() == 4);

        std::vector<cv::Point3d> points;
        Eigen::Vector3d avg_position = Eigen::Vector3d::Zero();
        for (int n = 0; n < 4; ++n) // corners
        {
          cv::Point2d left_uv_rect;
          left_uv_rect.x = left_markers->markers[i].u_corners[n];
          left_uv_rect.y = (left_markers->markers[i].v_corners[n] + right_markers->markers[j].v_corners[n]) / (double)2.0;
          cv::Point3d point_xyz;
          projectDisparityTo3d(left_uv_rect, disparity[n], point_xyz);
          // ROS_INFO("%i (n=%i) | %.2f %.2f %.2f", id, n, point_xyz.x, point_xyz.y, point_xyz.z);
          // publishMarker(n, id, point_xyz, markers_stamp);
          avg_position += Eigen::Vector3d(point_xyz.x, point_xyz.y, point_xyz.z);
          points.push_back(point_xyz);
        }
        avg_position /= (double)4.0;
        ROS_ASSERT(points.size() == 4);

        // average the two quaternions
        Eigen::Vector4d avg_quaternion;
        Eigen::Vector4d left_quaternion(left_markers->markers[i].quaternion.w,
                                        left_markers->markers[i].quaternion.x,
                                        left_markers->markers[i].quaternion.y,
                                        left_markers->markers[i].quaternion.z);
        left_quaternion *= left_markers->markers[i].confidence;
        Eigen::Vector4d right_quaternion(right_markers->markers[j].quaternion.w,
                                         right_markers->markers[j].quaternion.x,
                                         right_markers->markers[j].quaternion.y,
                                         right_markers->markers[j].quaternion.z);
        right_quaternion *= right_markers->markers[j].confidence;
        if(left_quaternion.dot(right_quaternion) > 0)
        {
          avg_quaternion = left_quaternion + right_quaternion;
        }
        else
        {
          avg_quaternion = left_quaternion - right_quaternion;
        }
        avg_quaternion /= avg_quaternion.norm();
        Eigen::Quaterniond quaternion(avg_quaternion(0), avg_quaternion(1), avg_quaternion(2), avg_quaternion(3));
        ROS_ASSERT(fabs((double)(1.0 - quaternion.norm())) < 10e-5);
        tf::Quaternion marker_quaternion(quaternion.x(), quaternion.y(), quaternion.z(), quaternion.w());

        std::vector<Eigen::Vector3d> corners;
        for (int n = 0; n < 4; ++n)
        {
          corners.push_back(Eigen::Vector3d(points[n].x, points[n].y, points[n].z));
          // ROS_INFO("corners: %f %f %f.", corners.back()(0), corners.back()(1), corners.back()(2));
        }

        // compute corner distances of neighboring corners
        bool skipping = false;
        for (int n = 0; !skipping && n < 4; ++n)
        {
          double distance = (corners[n] - corners[(n+1)%4]).norm();
          if(distance > MAX_CORNER_DISTANCE)
          {
            ROS_DEBUG("Maximum corner distance >%f< exceeded >%f<. Skipping marker with id >%i<.", MAX_CORNER_DISTANCE, distance, id);
            skipping = true;
          }
        }

        // check for NANs
        for (int n = 0; !skipping && n < 4; ++n)
        {
          if(std::isnan<double>((double)corners[n](0)) || std::isnan<double>((double)corners[n](1)) || std::isnan<double>((double)corners[n](2)))
          {
            ROS_WARN("Maximum corner point contains NAN. Skipping marker with id >%i<.", id);
            skipping = true;
          }
        }
        if(std::isnan<double>((double)avg_position(0)) || std::isnan<double>((double)avg_position(1)) || std::isnan<double>((double)avg_position(2)))
        {
          ROS_WARN("Maximum corner point contains NAN. Skipping marker with id >%i<.", id);
          skipping = true;
        }


        if (!skipping)
        {

          std::vector<Eigen::Vector3d> midsections;
          for (int n = 0; n < 4; ++n)
          {
            midsections.push_back((corners[n] + corners[(n + 1) % 4]) / (double)2.0);
            // ROS_INFO("midsections: %f %f %f.", midsections.back()(0), midsections.back()(1), midsections.back()(2));
          }

          std::vector<Eigen::Vector3d> axes;
          for (int n = 0; n < 4; ++n)
          {
            Eigen::Vector3d axis = midsections[n] - midsections[(n + 2) % 4];
            axis.normalize();
            axes.push_back(axis);
            // ROS_INFO("axes: %f %f %f.", axes.back()(0), axes.back()(1), axes.back()(2));
          }

          tf::Matrix3x3 marker_rot_matrix;
          marker_rot_matrix.setRotation(marker_quaternion);
          Eigen::Vector3d marker_rot_x(marker_rot_matrix.getColumn(0).getX(),
                                       marker_rot_matrix.getColumn(0).getY(),
                                       marker_rot_matrix.getColumn(0).getZ());
          Eigen::Vector3d marker_rot_y(marker_rot_matrix.getColumn(1).getX(),
                                       marker_rot_matrix.getColumn(1).getY(),
                                       marker_rot_matrix.getColumn(1).getZ());
          Eigen::Vector3d marker_rot_z(marker_rot_matrix.getColumn(2).getX(),
                                       marker_rot_matrix.getColumn(2).getY(),
                                       marker_rot_matrix.getColumn(2).getZ());

          int x_index = 0;
          double max_dot = 0.0;
          for (int n = 0; n < 4; ++n)
          {
            double dot = marker_rot_x.dot(axes[n]);
            if (dot > max_dot)
            {
              max_dot = dot;
              x_index = n;
            }
          }

          max_dot = 0.0;
          int y_index = 0;
          for (int n = 0; n < 4; ++n)
          {
            double dot = marker_rot_y.dot(axes[n]);
            if (dot > max_dot)
            {
              max_dot = dot;
              y_index = n;
            }
          }

          Eigen::Vector3d z_axis = axes[x_index].cross(axes[y_index]);
          z_axis.normalize();
          Eigen::Vector3d x_axis = axes[x_index];
          x_axis.normalize();
          Eigen::Vector3d y_axis = z_axis.cross(x_axis);
          y_axis.normalize();

          tf::Matrix3x3 mat(x_axis(0), y_axis(0), z_axis(0), x_axis(1), y_axis(1), z_axis(1), x_axis(2), y_axis(2), z_axis(2));
          mat.getRotation(marker_quaternion);

          Eigen::Vector4d q;
          q(0) = marker_quaternion.getW();
          q(1) = marker_quaternion.getX();
          q(2) = marker_quaternion.getY();
          q(3) = marker_quaternion.getZ();
          if(fabs(q.norm() - (double)1.0) > 1e-5)
          {
            ROS_WARN("Quaternion not normalized >%f<, skipping marker with id >%i<.", q.norm(), id);
          }
          else
          {
            tf::Vector3 marker_position(avg_position(0), avg_position(1), avg_position(2));
            tf::Transform marker_transform(marker_quaternion, marker_position);

            ROS_DEBUG(
                "marker_static_transform (%i): %f %f %f", id, marker_static_transforms_[id].getOrigin().getX(), marker_static_transforms_[id].getOrigin().getY(), marker_static_transforms_[id].getOrigin().getZ());

            marker_transforms_.push_back(marker_transform * marker_static_transforms_[id]);
            marker_confidences_.push_back(left_markers->markers[i].confidence * right_markers->markers[j].confidence);

            double confidence = left_markers->markers[i].confidence * right_markers->markers[j].confidence;
            if(confidence < confidence_threshold_)
            {
              ROS_DEBUG("Skipping 3d marker with id >%i< because confidence is >%.2f< and therefore lower then the threshold >%f<.",
                        id, confidence, confidence_threshold_);
            }
            else
            {
              ar_target::ARMarker3d marker;
              for (int n = 0; n < 4; ++n)
              {
                marker.id = id;
                marker.confidence = confidence;
                geometry_msgs::Quaternion q;
                q.w = marker_quaternion.getW();
                q.x = marker_quaternion.getX();
                q.y = marker_quaternion.getY();
                q.z = marker_quaternion.getZ();
                marker.corner_orientations.push_back(q);
                geometry_msgs::Point p;
                p.x = points[n].x;
                p.y = points[n].y;
                p.z = points[n].z;
                marker.corner_positions.push_back(p);
                tf::poseTFToMsg(marker_transform, marker.center_pose);
                marker.left_u_corners = left_markers->markers[i].u_corners;
                marker.left_v_corners = left_markers->markers[i].v_corners;
                marker.right_u_corners = right_markers->markers[j].u_corners;
                marker.right_v_corners = right_markers->markers[j].v_corners;
              }
              markers.markers.push_back(marker);
            }
          }
        }
      }
    }
  }

  marker_pub_.publish(markers);

  ros::Time rviz_now = ros::Time::now();
  ROS_DEBUG("Found >%i< markers.", (int)markers.markers.size());
  marker_index_ = 0;
  marker_array_->markers.resize((int)markers.markers.size() * (4+1+1));
  for (int i = 0; i < (int)markers.markers.size(); ++i)
  {
    addRvizMarker3d(markers.markers[i], rviz_now);
  }
  rviz_marker_pub_.publish(marker_array_);

  if (!marker_transforms_.empty())
  {
    // processMarkerTransforms(markers_stamp);
  }
  else
  {
    ROS_WARN("Could not find 3d marker match (left >%i< | right >%i<).",
              (int)left_markers->markers.size(), (int)right_markers->markers.size());
  }
}

void ARSynchronize::processMarkerTransforms(const ros::Time& time_stamp)
{
  ROS_ASSERT(!marker_transforms_.empty());
  ROS_ASSERT(marker_transforms_.size() == marker_confidences_.size());

  const double CONFIDENCE_THRESHOLD = 0.65;

  tf::Transform transform;
  if(marker_transforms_.size() == 1)
  {
    if(marker_confidences_[0] > CONFIDENCE_THRESHOLD)
    {
      transform = marker_transforms_[0];
      publishTransform(transform, time_stamp);
    }
    return;
  }
  else //if(marker_transforms_.size() == 2)
  {
    // check on the confidences
    std::vector<int> indices;
    for (int i = 0; i < (int)marker_transforms_.size(); ++i)
    {
      if(marker_confidences_[i] > CONFIDENCE_THRESHOLD)
      {
        indices.push_back(i);
      }
    }
    if(indices.size() != 2)
    {
      if(indices.size() == 1)
      {
        ROS_DEBUG("Insufficient confidence of marker >%i< >%f<. Not using it.", 1-indices[0], marker_confidences_[1-indices[0]]);
        transform = marker_transforms_[indices[0]];
        publishTransform(transform, time_stamp);
        return;
      }
      else
      {
        ROS_DEBUG("Insufficient confidence (marker1: >%f< marker2: >%f<). Skipping tf broadcast.",
                 marker_confidences_[0], marker_confidences_[1]);
        return;
      }
    }

    // compute avg position
    tf::Vector3 tf_position(0.0, 0.0, 0.0);
    for (int i = 0; i < (int)marker_transforms_.size(); ++i)
    {
      tf_position += marker_confidences_[i] * marker_transforms_[i].getOrigin();
    }
    //tf_position /= (double)marker_transforms_.size();
    tf_position /= (double)(marker_confidences_[0] + marker_confidences_[1]);
    transform.setOrigin(tf_position);

    // check whether quaternions are alinged
    Eigen::Vector4d quat1(marker_transforms_[0].getRotation().getW(), marker_transforms_[0].getRotation().getX(),
                          marker_transforms_[0].getRotation().getY(), marker_transforms_[0].getRotation().getZ());
    Eigen::Vector4d quat2(marker_transforms_[1].getRotation().getW(), marker_transforms_[1].getRotation().getX(),
                          marker_transforms_[1].getRotation().getY(), marker_transforms_[1].getRotation().getZ());
    // ROS_INFO("conf: %f %f", marker_confidences_[0], marker_confidences_[1]);
    double dot = quat1.dot(quat2);
    if (dot < 0.0)
    {
      quat1 = -quat1;
    }

    // avg quaternions and normalize
    Eigen::Vector4d quaternion = (marker_confidences_[0] * quat1) + (marker_confidences_[1] * quat2);
    quaternion.normalize();

    tf::Quaternion tf_quaternion(quaternion(1), quaternion(2), quaternion(3), quaternion(0));
    transform.setRotation(tf_quaternion);
  }
  //  else
  //  {
  //    ROS_ERROR("Detected >%i< markers. This is should never happen... skipping tf broadcast.", (int)marker_transforms_.size());
  //    return;
  //  }

  // TODO: remove this
  // transform = marker_transforms_[0];
  publishTransform(transform, time_stamp);
}

void ARSynchronize::publishTransform(const tf::Transform& transform, const ros::Time& time_stamp)
{
  tf::StampedTransform cam_to_marker(transform, time_stamp, left_camera_frame_, MARKER_FRAME);

  if(!std::isnan<double>(cam_to_marker.getOrigin().getX())
      && !std::isnan<double>(cam_to_marker.getOrigin().getY())
      && !std::isnan<double>(cam_to_marker.getOrigin().getZ())
      && !std::isnan<double>(cam_to_marker.getRotation().getW())
      && !std::isnan<double>(cam_to_marker.getRotation().getX())
      && !std::isnan<double>(cam_to_marker.getRotation().getY())
      && !std::isnan<double>(cam_to_marker.getRotation().getZ()))
  {
    tf_broadcaster_.sendTransform(cam_to_marker);
    // ROS_DEBUG("Published TF >%s< >%s<.", left_camera_frame_.c_str(), MARKER_FRAME.c_str());
  }

}

void ARSynchronize::addRvizMarker3d(const ar_target::ARMarker3d& marker, const ros::Time& time_stamp)
{
  const double SPHERE_RADIUS = 0.016;
  ROS_ASSERT(marker.corner_orientations.size() == 4);
  ROS_ASSERT(marker.corner_positions.size() == 4);
  for (int i = 0; i < 4; ++i)
  {
    visualization_msgs::Marker rviz_corner_marker;
    rviz_corner_marker.pose.position = marker.corner_positions[i];
    rviz_corner_marker.pose.orientation = marker.corner_orientations[i];

    // rviz_corner_marker.header.frame_id = left_camera_frame_;
    rviz_corner_marker.header.frame_id = left_camera_frame_;
    rviz_corner_marker.header.stamp = time_stamp;
    rviz_corner_marker.id = i;
    rviz_corner_marker.ns.assign("ARMarker3d_" + boost::lexical_cast<std::string>(marker.id) + "_corner_" + boost::lexical_cast<std::string>(i));

    rviz_corner_marker.scale.x = SPHERE_RADIUS;
    rviz_corner_marker.scale.y = SPHERE_RADIUS;
    rviz_corner_marker.scale.z = SPHERE_RADIUS;

    rviz_corner_marker.type = visualization_msgs::Marker::SPHERE;
    rviz_corner_marker.action = visualization_msgs::Marker::MODIFY;

    rviz_corner_marker.color.r = 0.0;
    rviz_corner_marker.color.g = 206.0/256.0;
    rviz_corner_marker.color.b = 209.0/256.0;
    rviz_corner_marker.color.a = 0.9;

    rviz_corner_marker.lifetime = ros::Duration(RVIZ_MARKER_LIFETIME);
    marker_array_->markers[marker_index_] = rviz_corner_marker;
    marker_index_++;
  }

  visualization_msgs::Marker rviz_center_marker;
  rviz_center_marker.pose = marker.center_pose;

  rviz_center_marker.header.frame_id = left_camera_frame_;
  rviz_center_marker.header.stamp = time_stamp;
  rviz_center_marker.id = 4;
  rviz_center_marker.ns.assign("ARMarker3d_center_" + boost::lexical_cast<std::string>(marker.id));

  rviz_center_marker.scale.x = 0.101;
  rviz_center_marker.scale.y = 0.101;
  rviz_center_marker.scale.z = 0.001;

  rviz_center_marker.type = visualization_msgs::Marker::CUBE;
  rviz_center_marker.action = visualization_msgs::Marker::MODIFY;

  rviz_center_marker.color.r = 1.0;
  rviz_center_marker.color.g = 0.0;
  rviz_center_marker.color.b = 0.0;
  rviz_center_marker.color.a = 0.9;

  rviz_center_marker.lifetime = ros::Duration(RVIZ_MARKER_LIFETIME);
  marker_array_->markers[marker_index_] = rviz_center_marker;
  marker_index_++;

  visualization_msgs::Marker rviz_text_marker;
  rviz_text_marker.pose = marker.center_pose;
  rviz_text_marker.pose.position.y -= 0.02;

  rviz_text_marker.header.frame_id = left_camera_frame_;
  rviz_text_marker.header.stamp = time_stamp;
  rviz_text_marker.id = 5;
  rviz_text_marker.ns.assign("ARMarker3d_text_" + boost::lexical_cast<std::string>(marker.id));
  rviz_text_marker.scale.z = 0.04;

  std::stringstream ss;
  ss << std::setprecision(2);
  ss << marker.confidence;
  rviz_text_marker.text.assign("id:" + boost::lexical_cast<std::string>(marker.id+1) + "\n" + ss.str());

  rviz_text_marker.type = visualization_msgs::Marker::TEXT_VIEW_FACING;
  rviz_text_marker.action = visualization_msgs::Marker::MODIFY;

  rviz_text_marker.color.r = 0.0;
  rviz_text_marker.color.g = 1.0;
  rviz_text_marker.color.b = 0.0;
  rviz_text_marker.color.a = 1.0;

  rviz_text_marker.lifetime = ros::Duration(RVIZ_MARKER_LIFETIME);
  marker_array_->markers[marker_index_] = rviz_text_marker;
  marker_index_++;
}

}

int main(int argc,
         char **argv)
{
  ros::init(argc, argv, "ARSynchronize");
  ros::NodeHandle node_handle("~");
  ar_target::ARSynchronize ar_synchronize(node_handle);
  ar_synchronize.run();
  return 0;
}

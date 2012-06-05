/*
 *  Single Marker Pose Estimation using ARToolkit
 *  Copyright (C) 2010 CCNY Robotics Lab
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

#ifndef AR_POSE_AR_SINGLE_H
#define AR_POSE_AR_SINGLE_H


// local includes
#include <ar_target/ar_base.h>

namespace ar_target
{

class ARSinglePublisher : public ARBase
{

public:

  ARSinglePublisher(ros::NodeHandle node_handle);
  virtual ~ARSinglePublisher();

private:

  void arInit();
  void camInfoCallback(const sensor_msgs::CameraInfoConstPtr &);
  void getTransformationCallback(const sensor_msgs::ImageConstPtr &);

  ar_target::ARMarker ar_target_marker_;

  tf::Transform marker_offset_;

}; // end class ARSinglePublisher

} // end namespace ar_target

#endif

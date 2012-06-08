#!/usr/bin/env python
import sys
import roslib; roslib.load_manifest('arm_fiducial_cal')
import rospy
import sys, os.path
from arm_fiducial_cal.urdf_utils import update_sensors_values_urdf
from arm_dashboard_client import DashboardClient
from geometry_msgs.msg import Transform

def main():
    rospy.init_node('UpdateURDF')
    dashboard_client = DashboardClient()
    
    fixed_bb_offset_path = os.path.join(roslib.packages.get_pkg_dir("arm_fiducial_cal"), "calib/fixed_offset.txt")
    print 'Reading %s' % fixed_bb_offset_path
    
    with open(fixed_bb_offset_path) as f:
        x, y, z, qw, qx, qy, qz = [float(x) for x in f.readline().split()]
        print x, y, z, qw, qx, qy, qz
    
    bb_left_neck_tf = Transform()
    bb_left_neck_tf.translation.x = x
    bb_left_neck_tf.translation.y = y
    bb_left_neck_tf.translation.z = z
    bb_left_neck_tf.rotation.w = qw
    bb_left_neck_tf.rotation.x = qx
    bb_left_neck_tf.rotation.y = qy
    bb_left_neck_tf.rotation.z = qz

    # write out the resulting cal file to the urdf
    urdf_path = os.path.join(roslib.packages.get_pkg_dir("arm_robot_model"), "models/sensorsValues.urdf.xacro")
    print 'Updating URDF in %s' % urdf_path
    update_sensors_values_urdf(urdf_path, bb_left_neck_tf, None, None, None)

if __name__ == "__main__":
    main()

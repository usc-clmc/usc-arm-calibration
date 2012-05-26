'''
Module that built on top of rospy that handles many of the common tasks
that ROS nodes need.

Jon Binney
2010.12.18
'''
import rospy
import atexit

# Import the main components of this module.
import threaded, rospath, trimesh, tf, marker_pub, viz_manager

# Hack by MRINAL for fuerte: shell module didn't work

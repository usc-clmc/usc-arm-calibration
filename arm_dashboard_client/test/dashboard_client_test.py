#!/usr/bin/env python
import roslib
roslib.load_manifest('arm_dashboard_client')
import rospy

from arm_dashboard_client import DashboardClient

rospy.init_node('DashboardClientTest', log_level=rospy.DEBUG)
rospy.loginfo('Started DashboardClientTest node.')

dashboard_client = DashboardClient()

while not rospy.is_shutdown():
    dashboard_client.debug("Testing dashboard client (debug).")
    dashboard_client.info("Testing dashboard client (info).")
    dashboard_client.warn("Testing dashboard client (warn).")
    dashboard_client.error("Testing dashboard client (error).")
    dashboard_client.fatal("Testing dashboard client (fatal).")
    rospy.sleep(1.0)

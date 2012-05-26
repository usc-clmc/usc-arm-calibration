#!/usr/bin/env python
import sys
import roslib; roslib.load_manifest('arm_calibrate_extrinsics')
import rospy
from arm_calibrate_extrinsics.srv import *

from arm_dashboard_client import DashboardClient

def main():
  rospy.init_node('CallCalibrateExtrinsics3D')
  dashboard_client = DashboardClient()

  rospy.wait_for_service('/CalibrateExtrinsics3D/calibrateExtrinsics3D')
  rospy.sleep(3);
  try:
      calibrate_extrinsics = rospy.ServiceProxy('/CalibrateExtrinsics3D/calibrateExtrinsics3D', CalibrateExtrinsics)
      resp = calibrate_extrinsics()
      if resp.result == CalibrateExtrinsicsResponse.SUCCEEDED:
          dashboard_client.info("Extrinsics calibration was successful. Please continue with the hand-eye calibration.")
          return True
      dashboard_client.error("There was a problem with the extrinsics calibration. Please repeat.")
      return False
  except rospy.ServiceException, e:
      dashboard_client.error("Service call failed: %s"%e)
            
if __name__=="__main__":
  main()

import roslib; roslib.load_manifest('arm_fiducial_cal')
import sys, os.path, time
import numpy as np
import matplotlib
matplotlib.use('GTK')
from matplotlib import pyplot as plt
from scipy import linalg, optimize
import rospy, rosbag
from tf import transformations
from cv_bridge import CvBridge

from pier import geom, ros_util, markers, viz_manager
from arm_fiducial_cal.urdf_utils import update_sensors_values_urdf
import arm_fiducial_cal.planes

from arm_fiducial_cal import FCOptimizer, FCFrame, FCViz, FCParams

cache_dir = roslib.packages.get_pkg_subdir('arm_fiducial_cal', 'cache')
s = shelve.open(os.path.join(cache_dir, 'cache.shelf'))
est_cam_H_neck = s['est_cam_H_neck']
s.close()

params = FCParams()
rospy.init_node('FiducialCalDisplayTransform')
rospy.sleep(1.0)
viz = viz_manager.VizManager('/FiducialCal/markers')



while not rospy.is_shutdown():
    fcviz.update()
    rospy.sleep(0.1)


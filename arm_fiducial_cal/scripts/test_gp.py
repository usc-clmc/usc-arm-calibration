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

from pier import geom, ros_util, markers, viz_manager, store
from arm_fiducial_cal.urdf_utils import update_sensors_values_urdf
import arm_fiducial_cal.planes

from arm_fiducial_cal import FCOptimizer, FCFrame, FCViz, FCParams, FCTransformCorrecter

params = FCParams()
cache_dir = roslib.packages.get_pkg_subdir('arm_fiducial_cal', 'cache')
s = store.Store(cache_dir)
upright_frames = s['upright_frames']
est_base_H_target = s['est_base_H_target']
est_cam_H_neck = s['est_cam_H_neck']

correcter = FCTransformCorrecter(cache_dir)

###############################################
# Display results in rviz
###############################################

true_color = (1.0, 0.0, 1.0, 1.0)
initial_color = (0.0, 1.0, 1.0, 1.0)
estimated_color = (1.0, 1.0, 0.0, 1.0)
gp_color = (0.0, 1.0, 0.0, 1.0)

params = FCParams()
rospy.init_node('FiducialCal')
rospy.sleep(1.0)
fcviz = FCViz('/FiducialCal/markers', params.tf_target_points)

fcviz.draw_target(est_base_H_target, 'estimated_target_pose', true_color)
for f_i, f in enumerate(upright_frames):
    # use GP to predict actual base to camera transform
    cam_H_base = np.dot(est_cam_H_neck, f.neck_H_base)
    base_H_cam = linalg.inv(cam_H_base)
    base_H_ccam = correcter.get_corrected_transform(base_H_cam)
 
    # project points using corrected transform
    cf_marker_points = np.array([cf_p for (m_i, cf_p) in f.visible_markers])

    bf_marker_points = geom.transform_points(cf_marker_points, base_H_cam)
    m = markers.points('/BASE', 'points_%d' % f_i, 0, 0.003, estimated_color, bf_marker_points)
    fcviz.viz.add(m)
    
    corrected_bf_marker_points = geom.transform_points(cf_marker_points, base_H_ccam)
    m = markers.points('/BASE', 'corrected_points_%d' % f_i, 0, 0.003, gp_color, corrected_bf_marker_points)
    fcviz.viz.add(m)
    fcviz.update()

while not rospy.is_shutdown():
    fcviz.update()
    rospy.sleep(0.1)

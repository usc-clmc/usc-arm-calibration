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

from arm_fiducial_cal import FCFrame, FCViz, FCParams, FCSingleFrameOpt, FCParametrizer

params = FCParams()
cache_dir = roslib.packages.get_pkg_subdir('arm_fiducial_cal', 'cache')
s = store.Store(cache_dir)
est_cam_H_neck = s['est_cam_H_neck']
est_base_H_target = s['est_base_H_target']
frames = s['frames']

true_color = (1.0, 0.0, 1.0, 1.0)
initial_color = (0.0, 1.0, 1.0, 1.0)
estimated_color = (1.0, 1.0, 0.0, 1.0)
gp_color = (0.0, 1.0, 0.0, 1.0)

rospy.init_node('FiducialCal')
fcviz = FCViz('/FiducialCal/markers', params.tf_target_points)
fcviz.draw_target(est_base_H_target, 'estimated_target_pose', true_color)

pm = FCParametrizer()
gp_training_inputs = []
gp_training_outputs = []
upright_frames = []
for f_i, f in enumerate(frames):
    bf_head_origin  = geom.transform_points(np.zeros(3), linalg.inv(f.neck_H_base))

    # hack to filter out poses where the lower pan-tilt isn't straight up
    if bf_head_origin[2] < 1.7:
        print 'Skipping frame %d (pan-tilt not in upright pose)' % f_i
        continue

    if len(f.visible_markers) < 4:
        print 'Skipping frame %d (only %d markers visible)' % (f_i, len(f.visible_markers))
        continue

    cam_H_base = np.dot(est_cam_H_neck, f.neck_H_base)
    base_H_cam = linalg.inv(cam_H_base)

    # should actually use the upper pan-tilt joint angles directly here...
    rpy = pm.matrix_to_rpy(base_H_cam)
    gp_training_inputs.append(rpy)

    opt = FCSingleFrameOpt(params.tf_target_points, est_base_H_target, est_cam_H_neck, f)
    est_params = opt.optimize()
    #plt.plot(opt.errors)
    #plt.show()
    gp_training_outputs.append(est_params)

    # project points using corrected transform
    cam_H_ccam = pm.params_to_matrix(est_params)
    base_H_ccam = np.dot(base_H_cam, cam_H_ccam)
    cf_marker_points = np.array([cf_p for (m_i, cf_p) in f.visible_markers])

    bf_marker_points = geom.transform_points(cf_marker_points, base_H_cam)
    m = markers.points('/BASE', 'points_%d' % f_i, 0, 0.003, estimated_color, bf_marker_points)
    fcviz.viz.add(m)
    
    corrected_bf_marker_points = geom.transform_points(cf_marker_points, base_H_ccam)
    m = markers.points('/BASE', 'corrected_points_%d' % f_i, 0, 0.003, gp_color, corrected_bf_marker_points)
    fcviz.viz.add(m)
    fcviz.update()

    print 'Frame %d: %d markers visible: %s -> %s' % (
        f_i, len(f.visible_markers), ' '.join(['%6.3f' % a for a in rpy]),
        ' '.join(['%6.3f' % p for p in est_params]))

    upright_frames.append(f)

s['gp_training_inputs'] = np.array(gp_training_inputs)
s['gp_training_outputs'] = np.array(gp_training_outputs)
s['upright_frames'] = upright_frames

while not rospy.is_shutdown():
    fcviz.update()
    rospy.sleep(0.1)

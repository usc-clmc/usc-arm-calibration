#!/usr/bin/env python
import roslib; roslib.load_manifest('arm_fiducial_cal')
import sys, os.path, time, shelve
import numpy as np
from scipy import linalg, optimize
from sklearn import gaussian_process
from matplotlib import pyplot as plt
import rospy, rosbag
from tf import transformations
from cv_bridge import CvBridge
from pier import geom, ros_util, markers, store
from arm_fiducial_cal.urdf_utils import update_sensors_values_urdf
import arm_fiducial_cal.planes

from arm_fiducial_cal import FCOptimizer, FCLoader, FCViz, FCParams, FCParametrizer, FCSingleFrameOpt, dist_ray_plane

if len(sys.argv) > 1:
    bag_file = sys.argv[1]
else:
    bag_dir = roslib.packages.get_pkg_subdir('arm_calibrate_extrinsics', 'data')
    bag_file = os.path.join(bag_dir, 'ar_target_frames_3d.bag')

true_color = (1.0, 0.0, 1.0, 1.0)
initial_color = (0.0, 1.0, 1.0, 1.0)
estimated_color = (1.0, 1.0, 0.0, 1.0)
corrected_color = (0.0, 1.0, 0.0, 1.0)

params = FCParams()
rospy.init_node('FiducialCal')
fcviz = FCViz('/FiducialCal/markers', params.tf_target_points)

print ''
print '===================================================================='
print 'Loading data from %s' % bag_file
print '===================================================================='

loader = FCLoader(bag_file, params)
frames = loader.frames

for f_i in range(len(frames)):
    markers_i = set([m_k for (m_k, p) in frames[f_i].visible_markers])
    print 'Markers visible in frame %d:' % f_i, sorted(markers_i)

print ''
print '===================================================================='
print 'Optimizing 6DOF transforms'
print '===================================================================='

tf_target_points = params.tf_target_points
est_base_H_target = params.initial_base_H_target
est_cam_H_neck = params.initial_cam_H_neck
for opt_i in range(2):
    # optimize only the base to target transform
    print ''
    print 'Optimizing base to target transform'
    opt = FCOptimizer(frames, tf_target_points, est_base_H_target, est_cam_H_neck, opt_frame='target')
    est_base_H_target, est_cam_H_neck = opt.optimize()

    # assuming the base to target transform we just computed is correct, optimize
    # the top-of-pan-tilt to left bumblebee transform
    print ''
    print 'Optimizing camera to top-of-pan-tilt transform'
    opt = FCOptimizer(frames, tf_target_points, est_base_H_target, est_cam_H_neck, opt_frame='cam')
    est_base_H_target, est_cam_H_neck = opt.optimize()

print ''
print '===================================================================='
print 'Calibration Results:'
print '===================================================================='

# print some statisticas about the optimization
est_bf_target_points = geom.transform_points(params.tf_target_points, est_base_H_target)
average_table_z = est_bf_target_points[:,2].mean()
print 'Target average z=%f' % average_table_z
opt.print_stats()

# write out the resulting cal file to the urdf
urdf_path = os.path.join(
    roslib.packages.get_pkg_dir("arm_robot_model"), "models/sensorsValues.urdf.xacro")
print 'Cal Successful! Writing result to URDF to %s' % urdf_path
bb_left_neck_tf = ros_util.matrix_to_transform(linalg.inv(est_cam_H_neck))
update_sensors_values_urdf(urdf_path, bb_left_neck_tf, None, None, None)

# write out table height (SL uses this)
table_height_path = os.path.join(
    roslib.packages.get_pkg_dir("arm_robot_model"), "calib/table_height.txt")
table_height_f  = open(table_height_path, 'w')
print >> table_height_f, '%0.3f' % average_table_z
table_height_f.close()

# write out the table bounds (used to crop point clouds)
table_xmax, table_ymax, table_zmax = est_bf_target_points.max(axis=0)
table_xmin, table_ymin, table_zmin = est_bf_target_points.min(axis=0)
table_xmax += .0375
table_ymax += .0375
table_xmin -= .0375
table_ymin -= .0375
table_bounds_path = os.path.join(
    roslib.packages.get_pkg_subdir("arm_fiducial_cal", "calib"), "table_bounds.txt")
table_bounds_f = open(table_bounds_path, 'w')
print >> table_bounds_f, ' '.join(['%0.3f' % v for v in [
    table_xmin, table_xmax, table_ymin, table_ymax, table_zmin, table_zmax]])
table_bounds_f.close()

print ''
print '===================================================================='
print 'Computing GP head correction'
print '===================================================================='

pm = FCParametrizer()
gp_training_inputs = []
gp_training_outputs = []
upright_frames = []
fcviz.draw_target(est_base_H_target, 'estimated_target_pose', true_color)
for f_i, f in enumerate(frames):
    bf_head_origin  = geom.transform_points(np.zeros(3), linalg.inv(f.neck_H_base))

    # hack to filter out poses where the lower pan-tilt isn't straight up
    if bf_head_origin[2] < 1.7:
        continue

    if len(f.visible_markers) < 6:
        print 'Skipping frame %d (only %d markers visible)' % (f_i, len(f.visible_markers))
        continue

    cam_H_base = np.dot(est_cam_H_neck, f.neck_H_base)
    base_H_cam = linalg.inv(cam_H_base)

    cf_marker_points = np.array([cf_p for (m_i, cf_p) in f.visible_markers])
    bf_marker_points = geom.transform_points(cf_marker_points, base_H_cam)

    # make sure the visible markers aren't colinear or something stupid
    vi = bf_marker_points[1] - bf_marker_points[0]
    vi /= linalg.norm(vi)
    spread = 0.0

    for bf_p in bf_marker_points[2:]:
        vj = bf_p - bf_marker_points[0]
        bf_p_proj = np.dot(vj, vi) * vj + bf_marker_points[0]
        dist_from_line = linalg.norm(bf_p_proj - bf_p)
        if dist_from_line > spread:
            spread = dist_from_line
    if spread < 0.1:
        print 'Skipping frame %d (spread is only %f)' % (f_i, spread)

    # train gp based on head joint angles
    head_joint_angles = np.array(f.joint_states.position)
    gp_training_inputs.append(head_joint_angles)

    opt = FCSingleFrameOpt(params.tf_target_points, est_base_H_target, est_cam_H_neck, f)
    est_params = opt.optimize()
    gp_training_outputs.append(est_params)

    # project points using corrected transform
    cam_H_ccam = pm.params_to_matrix(est_params)
    base_H_ccam = np.dot(base_H_cam, cam_H_ccam)
    m = markers.points('/BASE', 'points_%d' % f_i, 0, 0.003, estimated_color, bf_marker_points)
    fcviz.viz.add(m)
    
    corrected_bf_marker_points = geom.transform_points(cf_marker_points, base_H_ccam)
    m = markers.points('/BASE', 'corrected_points_%d' % f_i, 0, 0.003, corrected_color, corrected_bf_marker_points)
    fcviz.viz.add(m)
    fcviz.update()

    print 'Frame %d: n_markers=%d  spread=%.2f: %s -> %s' % (
        f.frame_id, len(f.visible_markers), spread, ' '.join(['%6.3f' % a for a in head_joint_angles]),
        ' '.join(['%6.3f' % p for p in est_params]))

    upright_frames.append(f)
gp_training_inputs = np.array(gp_training_inputs)
gp_training_outputs = np.array(gp_training_outputs)

# learn a correction gp for each of roll, pitch, yaw, x, y, z
correction_gps = []
for d in range(gp_training_outputs.shape[1]):
    gp = gaussian_process.GaussianProcess(theta0=1., thetaL=None, thetaU=None)
    gp.fit(gp_training_inputs, gp_training_outputs[:,d])
    correction_gps.append(gp)

# output gp inputs, gp outputs, and hyper-params to a yaml file
yamlfile_path = os.path.join(
    roslib.packages.get_pkg_dir("arm_fiducial_cal"), "calib/correction_gp.yaml")
yamlfile = open(yamlfile_path, 'w+')
print >> yamlfile, '# training inputs are head joint angles (LPAN, LTILT, UPAN, UTILT)'
print >> yamlfile, 'gp_training_inputs:'
for vec in gp_training_inputs:
    print >> yamlfile, '    - [' + ', '.join(['%7.3f' % x for x in vec]) + ']'
print >> yamlfile, '# training outputs are corrections for roll, pitch, yaw, x, y, z'
print >> yamlfile, '# of the frame of the top of the pan tilt unit'
print >> yamlfile, 'gp_training_outputs:'
for vec in gp_training_outputs:
    print >> yamlfile, '    - [' + ', '.join(['%7.3f' % x for x in vec]) + ']'
yamlfile.close()

# for our own purposes, save the estimated transform in a shelf
cache_dir = roslib.packages.get_pkg_subdir('arm_fiducial_cal', 'cache')
s = store.Store(cache_dir)
s['frames'] = frames
s['est_base_H_target'] = est_base_H_target
s['est_cam_H_neck'] = est_cam_H_neck
s['gp_training_inputs'] = gp_training_inputs
s['gp_training_outputs'] = gp_training_outputs
s['upright_frames'] = upright_frames

# make sure rviz gets all of the markers we published
for ii in range(10):  
    if not rospy.is_shutdown():
        fcviz.update()
        rospy.sleep(0.1)

print ''
print ''
print 'Head cal is all done!'




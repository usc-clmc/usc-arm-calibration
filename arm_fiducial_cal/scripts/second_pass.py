import roslib; roslib.load_manifest('arm_fiducial_cal')
import sys, os.path, time, shelve
import numpy as np
import matplotlib
matplotlib.use('GTK')
from matplotlib import pyplot as plt
from scipy import linalg, optimize
import rospy, rosbag
from tf import transformations
from cv_bridge import CvBridge

from pier import geom, ros_util, markers, store
from arm_fiducial_cal.urdf_utils import update_sensors_values_urdf
import arm_fiducial_cal.planes

from arm_fiducial_cal import FCOptimizer, FCFrame, FCViz, FCParams

params = FCParams()
rospy.init_node('FiducialCal')
rospy.sleep(1.0)
fcviz = FCViz('/FiducialCal/markers', params.tf_target_points)

# for our own purposes, save the estimated transform in a shelf
cache_dir = roslib.packages.get_pkg_subdir('arm_fiducial_cal', 'cache')
s = store.Store(cache_dir)
frames = s['frames']
est_base_H_target = s['est_base_H_target']
est_cam_H_neck = s['est_cam_H_neck']


upright_frames = []
for f_i, f in enumerate(frames):
    bf_head_origin  = geom.transform_points(np.zeros(3), linalg.inv(f.neck_H_base))

    # hack to filter out poses where the lower pan-tilt isn't straight up
    if bf_head_origin[2] > 1.7:
        print 'Skipping frame %d (pan-tilt not in upright pose)' % f_i
        upright_frames.append(f)

opt = FCOptimizer(frames, params.tf_target_points, est_base_H_target, est_cam_H_neck, fix_target_transform=True,
                  W=np.diag([1.0, 1.0, 10.0]))
new_est_base_H_target, new_est_cam_H_neck = opt.optimize()

opt.print_stats()

print np.dot(linalg.inv(new_est_cam_H_neck), est_cam_H_neck)

true_color = (1.0, 0.0, 1.0, 1.0)
initial_color = (0.0, 1.0, 1.0, 1.0)
estimated_color = (1.0, 1.0, 0.0, 1.0)

fcviz.draw_frames(upright_frames, est_cam_H_neck, 'new_initial_camera_poses', initial_color, cam_mark_lines=False)

fcviz.draw_target(est_base_H_target, 'estimated_target_pose', true_color)
fcviz.draw_frames(upright_frames, new_est_cam_H_neck, 'new_estimated_head_poses', estimated_color, cam_mark_lines=False)

# write out the resulting cal file to a urdf
urdf_path = os.path.join(
    roslib.packages.get_pkg_dir("arm_robot_model"), "models/sensorsValues.urdf.xacro")
print 'Cal Successful! Writing result to URDF to %s' % urdf_path
bb_left_neck_tf = ros_util.matrix_to_transform(linalg.inv(new_est_cam_H_neck))
update_sensors_values_urdf(urdf_path, bb_left_neck_tf, None, None, None)

while not rospy.is_shutdown():
    fcviz.update()
    rospy.sleep(0.1)



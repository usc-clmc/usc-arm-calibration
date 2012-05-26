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

def dist_ray_plane(r, abcd):
    '''
    Finds the distance along a ray (or rays) at which it interescts with
    the plane with coeffcients abcd.

    r - the unit vector direction of the ray (assumed to start at the origin)
    abcd - numpy array of the four plane coefficients: ax + by + cz + d = 0
    '''
    return -abcd[3] / np.dot(r, abcd[:3])


params = FCParams()
rospy.init_node('FiducialCal')
rospy.sleep(1.0)
fcviz = FCViz('/FiducialCal/markers', params.tf_target_points)

if len(sys.argv) > 1:
    bag_file = sys.argv[1]
else:
    bag_dir = roslib.packages.get_pkg_subdir('arm_calibrate_extrinsics', 'data')
    bag_file = os.path.join(bag_dir, 'ar_target_frames.bag')
bag = rosbag.Bag(bag_file)
print 'Loading data from %s' % bag_file

ros2cv = CvBridge()

# load the data from the bagfile
frames = []
for topic, msg, t in bag.read_messages():
    f = FCFrame()
    img = ros2cv.imgmsg_to_cv(msg.image)

    stereo_cloud = ros_util.pointcloud2_msg_to_cloud(msg.points)
    stereo_points = ros_util.cloud_to_points(stereo_cloud, remove_nans=False)
    stereo_points_flat = ros_util.cloud_to_points(stereo_cloud, remove_nans=True)

    # find plane in pointcloud        
    planefinder = arm_fiducial_cal.planes.PlaneFinder(
        stereo_points_flat, params.ransac_numpoints, params.ransac_numiters, params.inlier_dist)
    planefinder.compute()

    P = np.reshape(np.matrix(msg.camera_info.P), (3, 4))
    K_inv = linalg.inv(P[:3,:3])

    # get the base to neck transform
    f.neck_H_base = linalg.inv(ros_util.transform_to_matrix(msg.head_transform_base))

    # get image points from message
    for ii, marker_i in enumerate(msg.ids):
        u1, v1 = msg.u_corner_1[ii], msg.v_corner_1[ii]
        u2, v2 = msg.u_corner_2[ii], msg.v_corner_2[ii]
        u3, v3 = msg.u_corner_3[ii], msg.v_corner_3[ii]
        u4, v4 = msg.u_corner_4[ii], msg.v_corner_4[ii]
        corner_points_2d = np.array([(u1, v1), (u2, v2), (u3, v3), (u4, v4)], dtype=float)

        if not np.isfinite(corner_points_2d).all():
            print 'ERROR: NaN in 2D corner points!!'

        corner_points_3d = []
        for p_2d in corner_points_2d:
            p_2d = np.array((p_2d[0], p_2d[1], 1), dtype=np.float)
            ray_3d = np.dot(K_inv, p_2d)
            ray_3d /= linalg.norm(ray_3d)
            d = dist_ray_plane(ray_3d, planefinder.abcd)
            p = d*ray_3d
            
            if False:
                try:
                    p = stereo_points[p_2d[1], p_2d[0]]
                except IndexError:
                    print 'Point outside of image, skipping:', p
                    
            corner_points_3d.append(p)
        if len(corner_points_3d) < 4:
            # didn't have a stereo point for one of the corners
            continue

        cf_p = np.mean(corner_points_3d, axis=0)
        if np.isfinite(cf_p).all():
            f.visible_markers.append((marker_i, cf_p))
        else:
            print 'NaNs in center point, skipping marker:', cf_p


    frames.append(f)

errors = []
for f in frames:
    for marker_i, cf_p1 in f.visible_markers:
        for marker_j, cf_p2 in f.visible_markers:
            if not marker_i == marker_j:
                obs_dist = linalg.norm(cf_p1 - cf_p2)
                tgt_dist = linalg.norm(params.tf_target_points[marker_i] - params.tf_target_points[marker_j])
                err = np.abs(obs_dist-tgt_dist)
                print '%d, %d: obs_dist = %.3f, tgt_dist = %.3f, error = %.3f' % (
                    marker_i, marker_j, obs_dist, tgt_dist, err)
                errors.append(err)
#plt.hist(errors)
#plt.show()

# use the camera to neck transform from the last frame (should be the same for all frames though)
initial_cam_H_neck = linalg.inv(ros_util.transform_to_matrix(msg.cam_transform_head))

# run the optimization
for f_i in range(len(frames)):
    markers_i = set([m_k for (m_k, p) in frames[f_i].visible_markers])
    print 'Markers visible in frame %d:' % f_i, sorted(markers_i)

print ''
print '=========================='
print 'Optimizing...'

opt = FCOptimizer(frames, params.tf_target_points, params.initial_base_H_target, initial_cam_H_neck)
est_base_H_target, est_cam_H_neck = opt.optimize()

est_bf_target_points = geom.transform_points(params.tf_target_points, est_base_H_target)
print 'Target average z=%f' % est_bf_target_points[:,2].mean()

#print np.dot(linalg.inv(initial_cam_H_neck), est_cam_H_neck)

print ''
print '=========================='
print 'Results:'

opt.print_stats()

plt.plot(opt.errors)
plt.show()

true_color = (1.0, 0.0, 1.0, 1.0)
initial_color = (0.0, 1.0, 1.0, 1.0)
estimated_color = (1.0, 1.0, 0.0, 1.0)

fcviz.draw_frames(frames, initial_cam_H_neck, 'initial_camera_poses', initial_color, cam_mark_lines=False)

fcviz.draw_target(est_base_H_target, 'estimated_target_pose', estimated_color)
fcviz.draw_frames(frames, est_cam_H_neck, 'estimated_head_poses', estimated_color, cam_mark_lines=True)

# write out the resulting cal file to a urdf
urdf_path = os.path.join(
    roslib.packages.get_pkg_dir("arm_robot_model"), "models/sensorsValues.urdf.xacro")

print 'Cal Successful! Writing result to URDF to %s' % urdf_path
bb_left_neck_tf = ros_util.matrix_to_transform(linalg.inv(est_cam_H_neck))
update_sensors_values_urdf(urdf_path, bb_left_neck_tf, None, None, None)

# for our own purposes, save the estimated transform in a shelf
cache_dir = roslib.packages.get_pkg_subdir('arm_fiducial_cal', 'cache')
s = store.Store(cache_dir)
s['frames'] = frames
s['est_base_H_target'] = est_base_H_target
s['est_cam_H_neck'] = est_cam_H_neck
                
    
while not rospy.is_shutdown():
    fcviz.update()
    rospy.sleep(0.1)



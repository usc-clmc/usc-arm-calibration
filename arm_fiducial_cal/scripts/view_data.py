import roslib; roslib.load_manifest('arm_fiducial_cal')
import sys, os.path, time
import numpy as np
import matplotlib
matplotlib.use('GTK')
from matplotlib import pyplot as plt
from scipy import linalg, optimize
import rospy, rosbag
from tf import transformations
import pier.geom
from cv_bridge import CvBridge

from arm_fiducial_cal import FCOptimizer, FCFrame, FCViz, FCParams

debug = True

params = FCParams()

if len(sys.argv) > 1:
    bag_file = sys.argv[1]
else:
    bag_dir = roslib.packages.get_pkg_subdir('arm_calibrate_extrinsics', 'data')
    bag_file = os.path.join(bag_dir, 'ar_target_frames_3d.bag')

bag = rosbag.Bag(bag_file)

ros2cv = CvBridge()

fig = plt.figure()
left_img_ax = fig.add_subplot(1, 2, 1)
right_img_ax = fig.add_subplot(1, 2, 2)

# load the data from the bagfile
frame_id = -1
for topic, msg, t in bag.read_messages():
    frame_id += 1
    left_img = ros2cv.imgmsg_to_cv(msg.left_image)
    right_img = ros2cv.imgmsg_to_cv(msg.right_image)
    if frame_id == 20:
        left_img_ax.cla()
        right_img_ax.cla()        
        left_img_ax.imshow(left_img)
        right_img_ax.imshow(right_img)
        for m in msg.markers:
            left_corners = np.array([m.left_u_corners, m.left_v_corners]).T
            right_corners = np.array([m.right_u_corners, m.right_v_corners]).T
            left_img_ax.plot(left_corners[:,0], left_corners[:,1], 'o')
            right_img_ax.plot(right_corners[:,0], right_corners[:,1], 'o')

plt.show()
    

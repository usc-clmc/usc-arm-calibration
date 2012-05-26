import roslib; roslib.load_manifest('arm_fiducial_cal')
import shelve, sys, os, os.path, cProfile, tempfile, pstats
import numpy as np
from scipy import linalg
from matplotlib import pyplot as plt
import rospy
from sensor_msgs.msg import PointCloud2, PointField
from pier import marker_pub
from pier.viz_manager import VizManager

from arm_fiducial_cal.geom import *
from arm_fiducial_cal.ros_util import *
from arm_fiducial_cal.planes import *

def is_door_plane(pf):
    angle_from_z = np.arccos(np.dot(pf.abcd[:3], np.array((0.0, 0.0, 1.0))))
    if np.abs(angle_from_z - np.pi/2.0) > np.pi/6:
        print 'Angle wrong; not this plane'
        return False

    # check the width of this plane
    hor_vec = np.cross(pf.abcd[:3], np.array((0.0, 0.0, 1.0))) # should actually use table norm, not z-axis
    hor_dists = np.dot(pf.points, hor_vec)
    width = hor_dists.max() - hor_dists.min()
    print 'horizontal width:', hor_dists.max() - hor_dists.min()
    if width < 0.03 or width > 0.2:
        print 'Width wrong; not this plane'
        return False
    return True

if len(sys.argv) > 1:
    input_filename = sys.argv[1]
else:
    input_filename = os.path.expanduser('~/.ros/arm_fiducial_cal_state.shelf')
s = shelve.open(input_filename)
f = s['frame_list'][3]
s.close()

cloud = pointcloud2_msg_to_cloud(f['cloud_msg'])
points = cloud_to_points(cloud)
depths = (points*points).sum(axis=1)**0.5
#plt.scatter(points[:,0]/points[:,2], -points[:,1]/points[:,2], s=1, c=np.linspace(0., 1., len(points)), cmap='jet',
#            linewidths=np.zeros((len(points))))
#plt.show()

# transform to base frame
points = transform_points(points, np.array(f['transform']))
points = crop_to_bbox(points, -1.0, 1.0, 0.3, 1.3, 0.7, 2.0)

node_name = 'Planes'
rospy.init_node(node_name)

mpf = MultiPlaneFinder(points, 4, 10, 0.01, 100, include_dist=0.1)
mpf.compute()
for plane_i in range(len(mpf.pf_list)):
    pf = mpf.pf_list[plane_i]
    print 'Plane %d:' % (plane_i,), is_door_plane(pf)

cloud_pub = rospy.Publisher('%s/cloud' % node_name, PointCloud2)

# create point cloud topics for each plane
plane_cloud_pubs = []
for plane_i in range(len(mpf.pf_list)):
    pf = mpf.pf_list[plane_i]
    topic = '%s/planes/cloud%d' % (node_name, plane_i)
    pub = rospy.Publisher(topic, PointCloud2)
    plane_cloud_pubs.append(pub)

# create pub for rviz markers
plane_transform = make_plane_transform(mpf.pf_list[0].abcd, (0., 0., 1.))
origin = transform_point(plane_transform, np.array((0., 0., 0.)))
ivec = transform_vector(plane_transform, np.array((1., 0., 0.)))
jvec = transform_vector(plane_transform, np.array((0., 1., 0.)))
kvec = transform_vector(plane_transform, np.array((0., 0., 1.)))
viz = VizManager('%s/markers' % node_name)
m_list = marker_pub.axes('/BASE', 'axes', 0, origin, ivec, jvec, kvec, 0.2, 0.01)
for m in m_list:
    viz.add(m)

while not rospy.is_shutdown():
    print 'Spinning...'
    cloud_pub.publish(points_to_pymsg(points, rospy.Time.now(), '/BASE'))
    for plane_i in range(len(mpf.pf_list)):
        pf = mpf.pf_list[plane_i]
        plane_cloud_pubs[plane_i].publish(
            points_to_pymsg(pf.points[pf.inliers], rospy.Time.now(), '/BASE'))
    viz.update()
    rospy.sleep(1.0)

if 0:
    prof_filename = tempfile.NamedTemporaryFile().name
    cProfile.run('find_plane(points, 4, 10, 0.01)', prof_filename)
    p = pstats.Stats(prof_filename)
    p.sort_stats('time')
    p.print_stats(10)

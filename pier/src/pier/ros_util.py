import numpy as np
from sensor_msgs.msg import PointCloud2, PointField
from tf import transformations
from geometry_msgs.msg import Transform, Vector3, Quaternion

def pointcloud2_msg_to_cloud(cloud_msg):
    ''' Converts a rospy PointCloud2 message to a numpy recordarray 
    
    Assumes all fields 32 bit floats, and there is no padding.
    '''
    dtype_list = [(f.name, np.float32) for f in cloud_msg.fields]
    cloud_arr = np.fromstring(cloud_msg.data, dtype_list)
    return np.reshape(cloud_arr, (cloud_msg.height, cloud_msg.width))

def cloud_to_points(cloud, remove_nans=True):
    # remove crap points
    if remove_nans:
        mask = np.isfinite(cloud['x']) & np.isfinite(cloud['y']) & np.isfinite(cloud['z'])
        cloud = cloud[mask]
    
    # pull out x, y, and z values
    points = np.zeros(list(cloud.shape) + [3], dtype=np.float)
    points[...,0] = cloud['x']
    points[...,1] = cloud['y']
    points[...,2] = cloud['z']

    return points

def points_to_pointcloud2_msg(points, stamp=None, frame_id=None):
    '''
    Create a sensor_msgs.PointCloud2 from an array
    of points.
    '''
    #if len(points.shape) == 3:
    #    # 2d array of points. flatten them.
    #    flat_points = np.zeros((points.shape[0]*points.shape[1], 3), dtype=np.float)
    #    flat_points[:,0] = points[:,:,0].flatten()
    #    flat_points[:,1] = points[:,:,1].flatten()
    #    flat_points[:,2] = points[:,:,2].flatten()
    #else:
    #    flat_points = points


    msg = PointCloud2()
    if stamp:
        msg.header.stamp = stamp
    if frame_id:
        msg.header.frame_id = frame_id
    if len(points.shape) == 3:
        msg.height = points.shape[1]
        msg.width = points.shape[0]
    else:
        msg.height = 1
        msg.width = len(points)
    msg.fields = [
        PointField('x', 0, PointField.FLOAT32, 1),
        PointField('y', 4, PointField.FLOAT32, 1),
        PointField('z', 8, PointField.FLOAT32, 1)]
    msg.is_bigendian = False
    msg.point_step = 12
    msg.row_step = 12*points.shape[0]
    msg.is_dense = int(np.isfinite(points).all())
    msg.data = np.asarray(points, np.float32).tostring()
    return msg

def pose_to_matrix(pose_msg):
    ''' Convert a ros Transform message to a 4x4 homogeneous transform matrix '''
    rot = pose_msg.orientation
    q = np.array([rot.x, rot.y, rot.z, rot.w])
    pos = pose_msg.position
    t = np.array([pos.x, pos.y, pos.z])
    H_t = transformations.translation_matrix(t)
    H_r = transformations.quaternion_matrix(q)
    return np.matrix(np.dot(H_t, H_r))

def transform_to_matrix(transform_msg):
    ''' Convert a ros Transform message to a 4x4 homogeneous transform matrix '''
    rot = transform_msg.rotation
    q = np.array([rot.x, rot.y, rot.z, rot.w])
    trans = transform_msg.translation
    t = np.array([trans.x, trans.y, trans.z])
    H_t = transformations.translation_matrix(t)
    H_r = transformations.quaternion_matrix(q)
    return np.matrix(np.dot(H_t, H_r))

def matrix_to_transform(H):
    ''' Convert a 4x4 homogeneous transform matrix to a ros Transform message '''
    scale, shear, angles, trans, persp = transformations.decompose_matrix(H)
    q = transformations.quaternion_from_euler(*angles)
    transform_msg = Transform()
    transform_msg.translation = Vector3(*trans)
    transform_msg.rotation = Quaternion(*q)
    return transform_msg

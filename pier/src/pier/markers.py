import numpy as np
from visualization_msgs.msg import Marker
from geometry_msgs.msg import Point, Pose, Quaternion
import rospy

def transform_point(H, x):
    '''
    H - Homogeneous transformation as numpy matrix
    x - non-homogeneous point as numpy array
    returns: x transformed by H (non-homogeneous array)
    '''
    x_hom = np.ones((len(x)+1,))
    x_hom[:-1] = x
    xnew_hom = np.matrix(H) * np.matrix(x_hom).T
    xnew_hom = np.array(xnew_hom).flatten()
    return xnew_hom[:-1] / xnew_hom[-1]

def transform_vector(H, v):
    '''
    H - Homogeneous transformation as numpy matrix
    x - non-homogeneous point as numpy array
    returns: x transformed by H (non-homogeneous array)
    '''
    R = H[:3,:3] / H[3,3]
    vnew = np.matrix(R) * np.matrix(v).T
    return np.array(vnew).flatten()

def points(frame, ns, idnum, scale, color, point_arr):
    m = Marker()
    m.header.frame_id = frame
    m.header.stamp = rospy.Time.now()
    m.ns = ns
    m.type = Marker.POINTS
    m.action = Marker.ADD
    m.pose.position.x = 0.0
    m.pose.position.y = 0.0
    m.pose.position.z = 0.0
    m.pose.orientation.x = 0.0
    m.pose.orientation.y = 0.0
    m.pose.orientation.z = 0.0
    m.pose.orientation.w = 1.0
    m.scale.x, m.scale.y, m.scale.z = scale, scale, scale
    m.color.r, m.color.g, m.color.b, m.color.a = color
    m.lifetime = rospy.Duration()
    m.id = idnum
    class PointHack:
        pass
    for x in point_arr:
        p = PointHack()
        p.x = x[0]
        p.y = x[1]
        p.z = x[2]
        m.points.append(p)
    return m            

def sphere(frame, ns, idnum, x, scale, color):
    m = Marker()
    m.header.frame_id = frame
    m.header.stamp = rospy.Time.now()
    m.ns = ns
    m.type = Marker.SPHERE
    m.action = Marker.ADD
    m.pose.position.x = x[0]
    m.pose.position.y = x[1]
    m.pose.position.z = x[2]
    m.pose.orientation.x = 0.0
    m.pose.orientation.y = 0.0
    m.pose.orientation.z = 0.0
    m.pose.orientation.w = 1.0
    m.scale.x, m.scale.y, m.scale.z = scale, scale, scale
    m.color.r, m.color.g, m.color.b, m.color.a = color
    m.lifetime = rospy.Duration()
    m.id = idnum
    return m

def mesh_resource(frame, ns, idnum, color, mesh_uri, pose):
    m = Marker()
    m.header.frame_id = frame
    m.header.stamp = rospy.Time.now()
    m.ns = ns
    m.id = idnum
    m.type = Marker.MESH_RESOURCE
    m.action = Marker.ADD
    m.mesh_resource = mesh_uri
    m.pose = pose
    m.scale.x, m.scale.y, m.scale.z = 1.0, 1.0, 1.0
    m.color.r, m.color.g, m.color.b, m.color.a = color
    m.lifetime = rospy.Duration()
    return m
    

def cube(frame, ns, idnum, scale, color, x):
    m = Marker()
    m.header.frame_id = frame
    m.header.stamp = rospy.Time.now()
    m.ns = ns
    m.id = idnum
    m.type = Marker.CUBE
    m.action = Marker.ADD
    m.pose.position.x = x[0]
    m.pose.position.y = x[1]
    m.pose.position.z = x[2]
    m.pose.orientation.x = 0.0
    m.pose.orientation.y = 0.0
    m.pose.orientation.z = 0.0
    m.pose.orientation.w = 1.0
    m.scale.x, m.scale.y, m.scale.z = scale
    m.color.r, m.color.g, m.color.b, m.color.a = color
    m.lifetime = rospy.Duration()
    return m


def axes(frame, ns, idnum, origin, ivec, jvec, kvec, length, width):
    m_ivec = arrow(frame, ns, idnum, [origin, origin+length*ivec], width, (1.0, 0.0, 0.0, 1.0))
    m_jvec = arrow(frame, ns, idnum+1, [origin, origin+length*jvec], width, (0.0, 1.0, 0.0, 1.0))
    m_kvec = arrow(frame, ns, idnum+2, [origin, origin+length*kvec], width, (0.0, 0.0, 1.0, 1.0))
    return [m_ivec, m_jvec, m_kvec]


def arrow(frame, ns, idnum, points, width, color):
    m = Marker()
    m.type = Marker.ARROW
    m.action = Marker.ADD    
    m.scale.x = width
    m.scale.y = width*2
    m.color.r, m.color.g, m.color.b, m.color.a = color
    m.header.frame_id = frame
    m.header.stamp = rospy.Time.now()
    m.ns = ns

    for x in points:
        m.points.append(Point(*x))
    m.lifetime = rospy.Duration()
    m.id = idnum
    return m

def line_strip(frame, ns, idnum, width, color, points):
    m = Marker()
    m.type = Marker.LINE_STRIP
    m.action = Marker.ADD    
    m.scale.x = width
    m.color.r, m.color.g, m.color.b, m.color.a = color
    m.header.frame_id = frame
    m.header.stamp = rospy.Time.now()
    m.ns = ns

    class PointHack:
        pass
    for x in points:
        p = PointHack()
        p.x = x[0]
        p.y = x[1]
        p.z = x[2]
        
        m.points.append(p)
    m.lifetime = rospy.Duration()
    m.id = idnum
    return m

def line_list(frame, ns, idnum, width, color, points):
    m = Marker()
    m.type = Marker.LINE_LIST
    m.action = Marker.ADD    
    m.scale.x = width
    m.color.r, m.color.g, m.color.b, m.color.a = color
    m.header.frame_id = frame
    m.header.stamp = rospy.Time.now()
    m.ns = ns
    for x in points:
        m.points.append(Point(*x))
    m.lifetime = rospy.Duration()
    m.id = idnum
    return m

def from_cloud(cloud, transform, frame, ns, idnum, scale, color):
    # display the master cloud
    m = Marker()
    m.header.frame_id = frame
    m.header.stamp = rospy.Time.now()
    m.ns = ns
    m.type = Marker.POINTS
    m.action = Marker.ADD
    m.scale.x, m.scale.y, m.scale.z = scale, scale, scale
    m.color.r, m.color.g, m.color.b, m.color.a = color
    m.lifetime = rospy.Duration()
    m.id = idnum
    for p_i in range(len(cloud.points)):
        p = np.array((cloud.points[p_i].x, cloud.points[p_i].y, cloud.points[p_i].z))
        if np.isfinite(p).all():
            if transform != None:
                pt = transform_point(transform, p)
                m.points.append(Point(*pt))
            else:
                m.points.append(Point(*p))
    return m

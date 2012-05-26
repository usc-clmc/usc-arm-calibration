import shelve
from visualization_msgs.msg import Marker
from geometry_msgs.msg import Point
import rospy

def trimesh_from_file(filename):
    '''
    Load an object model from a python shelf
    '''
    s = shelve.open(filename)
    tm = s['trimesh']
    return tm

class TriMesh:
    '''
    Manipulating 3D models represented as a mesh of triangles

    Jon Binney
    2010.12.18
    '''
    def __init__(self, vertices, faces):
        self.vertices = vertices
        self.faces = faces

    def marker(self, color=(1.0, 1.0, 1.0), alpha=0.7, frame_id='/BASE',
                    ns='trimesh', idnum=0):
        '''
        Create and return an rviz TRIANGLE_LIST marker for this
        object. At the moment, rviz does not seem to support shading
        for this marker type, so using an alpha value < 1 makes
        the object a little easier to see.
        '''
        m = Marker()
        m.header.frame_id = '/BASE'
        m.header.stamp = rospy.Time.now()
        m.ns = ns
        m.type = Marker.TRIANGLE_LIST
        m.action = Marker.ADD
        m.pose.position.x = 0.0
        m.pose.position.y = 0.0
        m.pose.position.z = 0.0
        m.pose.orientation.x = 0.0
        m.pose.orientation.y = 0.0
        m.pose.orientation.z = 0.0
        m.pose.orientation.w = 1.0
        m.scale.x, m.scale.y, m.scale.z = 1.0, 1.0, 1.0
        m.color.r, m.color.g, m.color.b = color
        m.color.a = alpha
        m.lifetime = rospy.Duration()
        m.id = idnum
        import random
        for f in self.faces:
            for v_i in f:
                v = self.vertices[v_i]
                p = Point()
                p.x = v[0]
                p.y = v[1]
                p.z = v[2]
                m.points.append(p)

        return m
        
        
        

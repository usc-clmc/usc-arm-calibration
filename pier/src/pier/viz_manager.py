import threading
import rospy
from visualization_msgs.msg import Marker

class VizManager:
    '''
    Class that manages data visualization using rviz.
    '''
    def __init__(self, topic):
        ''' Create an rviz manager that publishes markers on the given topic '''
        self.lock = threading.Lock()
        self.marker_pub = rospy.Publisher(topic, Marker)
        self.markers = {}

    def add(self, m):
        ''' Add a marker to display '''
        with self.lock:
            if not m.ns in self.markers:
                self.markers[m.ns] = {}
            self.markers[m.ns][m.id] = m

    def update(self):
        ''' Send all markers to rviz '''
        with self.lock:
            for ns in sorted(self.markers):
                for idnum in sorted(self.markers[ns]):
                    self.marker_pub.publish(self.markers[ns][idnum])

    def clear(self):
        ''' Delete all markers '''
        with self.lock:
            for ns in sorted(self.markers):
                for idnum in sorted(self.markers[ns]):
                    self.markers[ns][idnum].action = Marker.DELETE
                    self.marker_pub.publish(self.markers[ns][idnum])
            self.markers = {}

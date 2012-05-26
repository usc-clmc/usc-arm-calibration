'''
Classes designed to handle ROS communication in a separate thread,
making it easier to write a robust and responsive ROS node in
python.

Jon Binney
2010.12.18
'''
import threading, Queue
import rospy
from sensor_msgs.msg import PointCloud
import numpy as np

class Subscription:
    '''
    Class that populates a buffer with incoming ROS messages for a particular
    topic.

    Uses locking to make get() and __len__() methods threadsafe, so
    that the main thread can call them whenever it is convenient.
    '''
    def __init__(self, topic, msg_type, queue_size, use_numpy=True):
        self.topic = topic
        self.msg_type = msg_type
        self.use_numpy = use_numpy
        self.msg_queue = Queue.Queue(maxsize=queue_size)
        self.lock = threading.Lock()
        
    def callback(self, msg):
        with self.lock:
            if self.msg_queue.full():
                self.msg_queue.get_nowait()
            self.msg_queue.put_nowait(msg)
        
    def pop(self):
        with self.lock:
            if self.msg_queue.empty():
                return None
            any_msg = self.msg_queue.get_nowait()
        msg = self.msg_type()            
        if self.use_numpy:
            msg.deserialize_numpy(any_msg._buff, np)            
        else:
            msg.deserialize(any_msg._buff)
        return msg

    def get_raw(self):
        with self.lock:
            if self.msg_queue.empty():
                return None
            any_msg = self.msg_queue.get_nowait()
        return any_msg

    def __len__(self):
        with self.lock:
            return self.msg_queue.qsize()
                
class Manager(threading.Thread):
    '''
    Class that manages ROS client duties in its own thread.

    Designed to effiently and robustly take care of things like ROS subscriptions, even if
    the other (main) thread is busy doing computations.
    '''
    def __init__(self, node_name):
        threading.Thread.__init__(self)
        self.node_name = node_name
        self.subscriptions = set()
        self.lock = threading.Lock()

        # All child threads (like the ones that rospy creates) inherit
        # this property. Python terminates as soon as all non-daemon threads
        # are complete, so this ensures that the process won't stay alive
        # because of ROS threads.
        self.daemon = True

    def run(self):
        '''
        Initialize the ros node, and then give up control to rospy.spin()

        Typically you do not call this function directly. Instead, call the start()
        member function of a ThreadedManager object (inherited from threading.Thread),
        which will create a new thread and then call this funciton.
        '''
        rospy.init_node(self.node_name, disable_signals=True)
        rospy.loginfo('Started ROS node %s', self.node_name)
        rospy.spin()

    def subscribe(self, topic, msg_type, queue_size=10, use_numpy=True):
        '''
        Subscribe to a topic and create a message queue for it
        
        Uses message type "AnyMsg", which does not deserialize incoming messages.
        This saves lots of CPU usage, and we can still deserialize individual
        messages whenever we want
        '''
        with self.lock:
            sub = Subscription(topic, msg_type, queue_size, use_numpy=use_numpy)
            rospy.Subscriber(topic, rospy.AnyMsg, sub.callback)
            self.subscriptions.add(sub)
            return sub

    def advertise(self, topic, msg_type):
        '''
        Advertises a new topic.
        '''
        pub = rospy.Publisher(topic, msg_type)
        return pub

    def shutdown(self, reason):
        with self.lock:
            rospy.signal_shutdown(reason)
            

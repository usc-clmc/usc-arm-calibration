import roslib
import sys, os.path, time
import numpy as np
from scipy import linalg, optimize
import rospy
import tf
from tf import transformations

from pier import geom, store, ros_util

from arm_fiducial_cal.fc_transform_correcter import FCTransformCorrecter

class FCCorrectionNode:
    def __init__(self, name):
        self.name = name
        self.ref_frame = '/BASE'
        self.orig_frame = '/BUMBLEBEE_LEFT_REAL'
        self.corrected_frame = '/BUMBLEBEE_LEFT'
        self.listener = tf.TransformListener(True, rospy.Duration(100.0))
        self.broadcaster = tf.TransformBroadcaster()

        self.cache_dir = roslib.packages.get_pkg_subdir('arm_fiducial_cal', 'cache', required=False)
        self.correcter = FCTransformCorrecter(self.cache_dir)
        
        self.prev_base_H_cam = None
        self.prev_base_H_ccam = None

    def publish_one_transform(self):
        t = rospy.Time.now()        
        try:
            self.listener.waitForTransform(
                self.ref_frame, self.orig_frame, t, rospy.Duration(1.0))
            (trans, rot) = self.listener.lookupTransform(
                self.ref_frame, self.orig_frame, t)
            base_H_cam = np.matrix(self.listener.fromTranslationRotation(trans, rot))
        except tf.Exception as ex:
            rospy.logerr('%s: Unable to get transform' % self.name)
            return

        # cache the last corrected transform to save on computation
        if (not self.prev_base_H_cam == None) and np.sum(np.abs(self.prev_base_H_cam - base_H_cam)) < 1e-10:
            base_H_ccam = self.prev_base_H_ccam
        else:
            base_H_ccam = self.correcter.get_corrected_transform(base_H_cam)
            self.prev_base_H_cam = base_H_cam
            self.prev_base_H_ccam = base_H_ccam
            
        transform_msg = ros_util.matrix_to_transform(base_H_ccam)
        trans = transform_msg.translation
        rot = transform_msg.rotation

        # broadcast the corrected transform
        self.broadcaster.sendTransform(
            (trans.x, trans.y, trans.z), (rot.x, rot.y, rot.z, rot.w), t, self.corrected_frame, self.ref_frame)

    def run(self):
        # let a few tf messages come in
        rospy.sleep(0.1)

        # loop, publishing corrected transforms
        while not rospy.is_shutdown():
            self.publish_one_transform()
            rospy.sleep(0.03)
        

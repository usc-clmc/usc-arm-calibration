import sys, os.path, time
import numpy as np
from scipy import linalg, optimize
from sklearn import gaussian_process
from tf import transformations
import rospy

from pier import geom, store

from arm_fiducial_cal.fc_parametrizer import FCParametrizer

class FCTransformCorrecter:
    def __init__(self, cache_dir):
        self.cache_dir = cache_dir
        try:
            self.store = store.Store(cache_dir)
            self.training_inputs = self.store['gp_training_inputs']
            self.training_outputs = self.store['gp_training_outputs']
            self.gps = []
            for d in range(self.training_outputs.shape[1]):
                gp = gaussian_process.GaussianProcess(theta0=1., thetaL=None, thetaU=None)
                gp.fit(self.training_inputs, self.training_outputs[:,d])
                self.gps.append(gp)
        except Exception, e:
            rospy.logerr('Could not load GP training data (did you run cal-set?); using identity correction')
            self.gps = None
            
        self.pm = FCParametrizer()

    def predict(self, x):
        params = []
        for gp in self.gps:
            y_pred, sigma2_pred = gp.predict(np.array([x]), eval_MSE=True)
            params.append(y_pred[0])
        params = np.array(params)
        return params
        
    def get_corrected_transform(self, base_H_cam):
        if self.gps == None:
            return base_H_cam
        
        rpy = self.pm.matrix_to_rpy(base_H_cam)
        correction_params = self.predict(rpy)
        cam_H_ccam = self.pm.params_to_matrix(correction_params)
        return np.dot(base_H_cam, cam_H_ccam)

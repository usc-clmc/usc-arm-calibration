import sys, os.path, time
import numpy as np
from scipy import linalg, optimize
from tf import transformations

from pier import geom, store

from arm_fiducial_cal.fc_parametrizer import FCParametrizer

class FCSingleFrameOpt:
    def __init__(self, tf_target_points, base_H_target, cam_H_neck, frame):
        self.tf_target_points = tf_target_points
        self.base_H_target = base_H_target
        self.cam_H_neck = cam_H_neck
        self.frame = frame
        self.bf_target_points = geom.transform_points(self.tf_target_points, self.base_H_target)
        self.pm = FCParametrizer()

    def calc_error(self, params):
        #params[:2] = 0.0
        cam_H_ccam = self.pm.params_to_matrix(params)
        neck_H_ccam = np.dot(linalg.inv(self.cam_H_neck), cam_H_ccam)

        err = 0.0
        num_corr = 0
        base_H_ccam = np.dot(linalg.inv(self.frame.neck_H_base), neck_H_ccam)
        for m_i, cf_p in self.frame.visible_markers:
            # position of marker in base frame as seen by camera
            bf_p = geom.transform_points(cf_p, base_H_ccam)

            # position of marker in base frame based on target position
            bf_p_target = self.bf_target_points[m_i]

            # error
            err += linalg.norm(bf_p - bf_p_target)
            num_corr += 1
        err /= num_corr
        self.errors.append(err)
        #print len(self.errors), ':', params, ':', '%.3f' % err
        return err

    def optimize(self):
        self.errors = []
        initial_params = np.zeros((6,), dtype=np.float)
        est_params = optimize.fmin(self.calc_error, initial_params, xtol=0.000000000001, ftol=0.003, maxiter=2000,
                               maxfun=2000, disp=False)
        #est_params[:2] = 0.0
        return est_params

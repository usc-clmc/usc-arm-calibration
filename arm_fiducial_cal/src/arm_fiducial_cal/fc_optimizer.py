import numpy as np
from scipy import linalg, optimize
from tf import transformations
import pier.geom

from arm_fiducial_cal.fc_parametrizer import FCParametrizer

class FCOptimizer:
    def __init__(self, frames, tf_target_points, initial_base_H_target, initial_cam_H_neck,
                 opt_frame, W=np.eye(3)):
        self.frames = frames
        self.tf_target_points = tf_target_points
        self.initial_base_H_target = initial_base_H_target
        self.initial_cam_H_neck = initial_cam_H_neck
        self.opt_frame = opt_frame        
        self.W = W
        self.pm = FCParametrizer()
        
    def calc_error(self, params):
        if self.opt_frame == 'target':
            base_H_target = self.pm.params_to_matrix(params)
            cam_H_neck = self.initial_cam_H_neck
        elif self.opt_frame == 'cam':
            base_H_target = self.initial_base_H_target
            cam_H_neck = self.pm.params_to_matrix(params)
        else:
            raise NotImplementedError

        bf_target_points = pier.geom.transform_points(self.tf_target_points, base_H_target)
        
        err = 0.0
        num_corr = 0
        for f_i, f in enumerate(self.frames):
            base_H_cam = linalg.inv(np.dot(cam_H_neck, f.neck_H_base))
            for m_i, cf_p in f.visible_markers:
                # position of marker in base frame as seen by camera
                bf_p = pier.geom.transform_points(cf_p, base_H_cam)

                # position of marker in base frame based on target position
                bf_p_target = bf_target_points[m_i]

                # error
                pdiff = bf_p - bf_p_target
                err += np.dot(pdiff, np.dot(self.W, pdiff))
                num_corr += 1
        err /= num_corr
        self.errors.append(err)
        if len(self.errors) % 400 == 0:
            print len(self.errors), ':', ' '.join(['%.3f' % x for x in params]), ':', '%.3f' % err**0.5
        return err
                
    def optimize(self):
        self.errors = []

        if self.opt_frame == 'target':
            initial_params = self.pm.matrix_to_params(self.initial_base_H_target)
        elif self.opt_frame == 'cam':
            initial_params = self.pm.matrix_to_params(self.initial_cam_H_neck)
        else:
            raise NotImplementedError

        
        est_params = optimize.fmin(self.calc_error, initial_params, xtol=0.000000000001, ftol=0.000001, maxiter=10000,
                               maxfun=10000)

        if self.opt_frame == 'target':
            self.base_H_target = self.pm.params_to_matrix(est_params)
            self.cam_H_neck = self.initial_cam_H_neck
        elif self.opt_frame == 'cam':
            self.base_H_target = self.initial_base_H_target
            self.cam_H_neck = self.pm.params_to_matrix(est_params)
        else:
            raise NotImplementedError

        return self.base_H_target, self.cam_H_neck

    def print_stats(self):
        '''
        Assumes self.optimize() has already been called.
        '''
        bf_target_points = pier.geom.transform_points(self.tf_target_points, self.base_H_target)

        per_frame_errors = []
        for f_i, f in enumerate(self.frames):
            base_H_cam = linalg.inv(np.dot(self.cam_H_neck, f.neck_H_base))

            frame_err = 0.0
            for m_i, cf_p in f.visible_markers:
                # position of marker in base frame as seen by camera
                bf_p = pier.geom.transform_points(cf_p, base_H_cam)

                # position of marker in base frame based on target position
                bf_p_target = bf_target_points[m_i]

                # error
                frame_err += linalg.norm(bf_p - bf_p_target)
            frame_err /= len(f.visible_markers)
            per_frame_errors.append(frame_err)
        print 'Per frame average errors:', ' '.join(['%6.3f' % frame_err for frame_err in per_frame_errors])


            

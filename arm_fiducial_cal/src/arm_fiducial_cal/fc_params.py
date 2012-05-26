import numpy as np
from scipy import linalg
import rospy
from tf import transformations
import pier.geom

from arm_fiducial_cal.fc_parametrizer import FCParametrizer

class FCParams:
    def __init__(self):
        self.target_num_rows = 4
        self.target_num_cols = 8
        self.target_col_width = 0.233
        self.target_row_height = 0.241

        # construct the grid of marker points in target coords
        tf_target_points = []
        for y in range(self.target_num_rows-1, -1, -1):
            for x in range(0, self.target_num_cols):
                tf_target_points.append(np.array((x, y, 0), dtype=float))
        self.tf_target_points = np.array(tf_target_points)
        self.tf_target_points[:,0] *= self.target_col_width
        self.tf_target_points[:,1] *= self.target_row_height

        pm = FCParametrizer()

        # initial guesses for cam to head and target to base trasnforms
        self.initial_base_H_target = np.eye(4)
        self.initial_base_H_target[:3,3] = (-0.8, 0.60, 0.78)

        # fix the head to camera transform, and optimize the table position
        neck_cam_params = np.array([0.061, 0.161, 0.05, 0.0, 0.0, 3.1415])
        self.initial_cam_H_neck = linalg.inv(pm.params_to_matrix(neck_cam_params))

        # other params for the estimate
        self.ransac_numpoints = 3
        self.ransac_numiters = 300
        self.inlier_dist = 0.002
        

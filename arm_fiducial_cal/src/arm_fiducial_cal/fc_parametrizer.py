import sys, os.path, time
import numpy as np
from scipy import linalg, optimize
from tf import transformations

from pier import geom, store

class FCParametrizer:
    def __init__(self):
        pass

    def params_to_matrix(self, params):
        # uses euler angles.... assumes we aren't near singularities
        translate = params[0:3]
        angles = params[3:6]
        return transformations.compose_matrix(translate=translate, angles=angles)
        
    def matrix_to_params(self, H):
        # uses euler angles.... assumes we aren't near singularities
        scale, sheer, angles, translate, perspective = transformations.decompose_matrix(H)
        return np.hstack((translate, angles))

    def params_to_rpy(self, params):
        return params[3:6]

    def matrix_to_rpy(self, H):
        params = self.matrix_to_params(H)
        return self.params_to_rpy(params)


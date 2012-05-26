from arm_fiducial_cal.fc_frame import FCFrame
from arm_fiducial_cal.fc_optimizer import FCOptimizer
from arm_fiducial_cal.fc_viz import FCViz
from arm_fiducial_cal.fc_params import FCParams
from arm_fiducial_cal.fc_single_frame_opt import FCSingleFrameOpt
from arm_fiducial_cal.fc_parametrizer import FCParametrizer
from arm_fiducial_cal.fc_transform_correcter import FCTransformCorrecter
from arm_fiducial_cal.fc_correction_node import FCCorrectionNode
from arm_fiducial_cal.fc_loader import FCLoader

import numpy as np

def dist_ray_plane(r, abcd):
    '''
    Finds the distance along a ray (or rays) at which it interescts with
    the plane with coeffcients abcd.

    r - the unit vector direction of the ray (assumed to start at the origin)
    abcd - numpy array of the four plane coefficients: ax + by + cz + d = 0
    '''
    return -abcd[3] / np.dot(r, abcd[:3])

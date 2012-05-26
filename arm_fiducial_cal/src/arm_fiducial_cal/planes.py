import numpy as np
from scipy import linalg
import random

def make_plane_transform(abcd, nref=None):
    '''
    Create a coordinate system for which z is parallel to the
    normal vector of the given plane, x, and y are arbitrary, and
    the origin is an arbitrary point on the plane.

    abcd - plane coefficients
    nref - if provided, a vector which has a positive dot product with
       the table plane vector (used to flip the z vector)
    '''
    # choose the unit vectors for the coord system
    kvec = abcd[:3].copy()
    kvec /= linalg.norm(kvec)
    if nref != None and np.dot(nref, kvec) < 0.0:
        kvec *= -1.0
    if np.abs(np.dot(kvec, (1., 0., 0.))) < np.abs(np.dot(kvec, (0., 1., 0.))):
        ivec = np.cross(kvec, (1., 0., 0.))
    else:
        ivec = np.cross(kvec, (0., 1., 0.))
    jvec = np.cross(kvec, ivec)

    # pick an arbitrary point on the plane
    if abcd[0]**2 > 0.1:
        p0 = np.array((-abcd[3]/abcd[0], 0., 0.))
    elif abcd[1]**2 > 0.1:
        p0 = np.array((0., -abcd[3]/abcd[1], 0.))
    else:
        p0 = np.array((0., 0., -abcd[3]/abcd[2]))

    # build the transform matrix
    H_rot = np.eye(4)
    H_rot[:3,0] = ivec
    H_rot[:3,1] = jvec
    H_rot[:3,2] = kvec
    H_trans = np.eye(4)
    H_trans[:3,3] = p0
    return np.dot(H_trans, H_rot)

def fit_plane_to_points(points):
    A = np.ones((len(points), 3), dtype=np.float)
    A[:,0] = points[:,0]
    A[:,1] = points[:,1]
    abd, res, rnk, s = linalg.lstsq(A, -points[:,2])
    abcd = np.array((abd[0], abd[1], 1.0, abd[2]))
    # normalize so that the vector abc has unit norm
    abcd = abcd / linalg.norm(abcd[:3])
    return abcd

def point_to_plane_dist(points, abcd):
    return np.abs(np.dot(points, abcd[:3]) + abcd[3]) / linalg.norm(abcd)

class MultiPlaneFinder:
    def __init__(self, points, ransac_npoints, ransac_numiters, inlier_dist, min_ppp, include_dist=None):
        '''
        points - Nx3 numpy array of points
        ransac_npoints - number of points to use to fit plane at each step
        ransac_numiters - number of ransac iterations to do for each plane
        inlier_dist - inlier distance to use when doing ransac to find a plane
        min_ppp - minimum number of points on a plane to add it
        include_dist - distance from a plane to consider a point "owned" by that plane
        '''
        self.points = points
        self.ransac_npoints = ransac_npoints
        self.ransac_numiters = ransac_numiters
        self.inlier_dist = inlier_dist
        self.min_ppp = min_ppp
        if include_dist == None:
            self.include_dist = inlier_dist
        else:
            self.include_dist = include_dist

    def compute(self):
        self.remaining_points = self.points.copy()
        self.pf_list = []
        while True:
            print 'Computing plane %d; %d points remaining' % (len(self.pf_list), len(self.remaining_points))
            pf = PlaneFinder(self.remaining_points, self.ransac_npoints, self.ransac_numiters, self.inlier_dist)
            if not pf.compute():
                print 'Failed to compute plane, stopping'
                break

            num_inliers = pf.inliers.sum()
            if num_inliers < self.min_ppp:
                print 'Too few inliers for plane (%d), stopping' % num_inliers
                break

            self.pf_list.append(pf)
            dists = point_to_plane_dist(self.remaining_points, pf.abcd)
            self.remaining_points = self.remaining_points[dists > self.include_dist]
            if len(self.remaining_points) < self.ransac_npoints:
                print 'Not enough remaining points to fit a plane'
                break
            
class PlaneFinder:
    def __init__(self, points, ransac_npoints, ransac_numiters, inlier_dist):
        self.points = points
        self.ransac_npoints = ransac_npoints
        self.ransac_numiters = ransac_numiters
        self.inlier_dist = inlier_dist
        self.inliers = None
        self.abcd = None

    def compute(self):
        best_num_inliers = -np.inf
        best_inliers = None
        best_abcd = None
        for ransac_i in range(self.ransac_numiters):
            # choose samples
            samples = random.sample(xrange(len(self.points)), self.ransac_npoints)
        
            # fit plane to samples
            abcd = fit_plane_to_points(self.points[samples])
            
            # count inliers
            dists = point_to_plane_dist(self.points, abcd)
            inliers = dists <= self.inlier_dist
            num_inliers = inliers.sum()
            if num_inliers > best_num_inliers:
                best_num_inliers = num_inliers
                best_inliers = inliers
                best_abcd = abcd
        self.abcd = best_abcd
        self.inliers = best_inliers
        return True

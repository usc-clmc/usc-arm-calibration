import numpy as np
from scipy import linalg
import rosbag

from pier import ros_util, geom
from arm_fiducial_cal.fc_frame import FCFrame

class FCLoader:
    def __init__(self, filename, params):
        self.params = params
        self.frames = []
        bag = rosbag.Bag(filename)
        self.load_frames_from_bag(bag)

    def load_frames_from_bag(self, bag):
        frame_id = -1
        for topic, msg, t in bag.read_messages():
            frame_id += 1
            frame = self.parse_frame_message(msg, frame_id)

            if len(frame.visible_markers) < 3:
                print 'Only %d markers visible, skipping frame %d' % (len(frame.visible_markers), frame.frame_id)
                continue

            max_marker_distance_err = self.max_intermarker_distance_error(frame)
            if max_marker_distance_err > 0.03:
                print 'Bad inter-marker distance (%0.3f), discarding frame %d' % (
                    max_marker_distance_err, frame.frame_id)
                continue

            self.frames.append(frame)

    def parse_frame_message(self, msg, frame_id):
        frame = FCFrame()
        frame.frame_id = frame_id

        # TODO: use uncalibrated transform to approximate point positions in base frame
        frame.neck_H_base = linalg.inv(ros_util.transform_to_matrix(msg.head_transform_base))
        cam_H_base = np.dot(self.params.initial_cam_H_neck, frame.neck_H_base)
        base_H_cam = linalg.inv(cam_H_base)

        # get image points from message
        for ii, marker in enumerate(msg.markers):
            p = marker.center_pose.position
            cf_center_point = np.array([p.x, p.y, p.z], dtype=np.float)

            if not np.isfinite(cf_center_point).all():
                print 'ERROR: NaN in 2D marker center point!!'
                continue

            frame.visible_markers.append((marker.id, cf_center_point))
        return frame


    def max_intermarker_distance_error(self, frame):
        '''
        Check distances between markers as a sanity check, and throw out frame
        '''
        max_marker_distance_err = 0.0
        for marker_i, cf_p1 in frame.visible_markers:
            for marker_j, cf_p2 in frame.visible_markers:
                if not marker_i == marker_j:
                    obs_dist = linalg.norm(cf_p1 - cf_p2)
                    tgt_dist = linalg.norm(
                        self.params.tf_target_points[marker_i] - self.params.tf_target_points[marker_j])
                    err = np.abs(obs_dist-tgt_dist)
                    if err > max_marker_distance_err:
                        max_marker_distance_err = err
        return max_marker_distance_err


    def fit_plane_to_markers(self, markers):
        # find plane in pointcloud        
        planefinder = arm_fiducial_cal.planes.PlaneFinder(
            cropped_stereo_points, self.params.ransac_numpoints, self.params.ransac_numiters, self.params.inlier_dist)
        planefinder.compute()

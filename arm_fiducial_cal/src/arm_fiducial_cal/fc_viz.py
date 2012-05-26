import numpy as np
from scipy import linalg
from pier import markers, viz_manager, geom

class FCViz:
    def __init__(self, topic, tf_target_points):
        self.viz = viz_manager.VizManager(topic)
        self.tf_target_points = tf_target_points

    def draw_target(self, base_H_target, ns='target_points', color=(0.0, 0.0, 1.0, 1.0)):
        bf_target_points = geom.transform_points(self.tf_target_points, base_H_target)
        m = markers.points('/BASE', ns, 0, 0.007, color, bf_target_points)
        self.viz.add(m)
        self.viz.update()

    def draw_head_pose(self, neck_H_base, cam_H_neck, ns, color):
        base_H_neck = linalg.inv(neck_H_base)
        neck_H_cam = linalg.inv(cam_H_neck)
        
        self.draw_transform(base_H_neck, scale=0.1, ns=ns, idnum=0)
        cam_H_base = np.dot(cam_H_neck, neck_H_base)
        base_H_cam = linalg.inv(cam_H_base)
        self.draw_transform(base_H_cam, scale=0.04, ns=ns, idnum=3)

        # draw a line from neck to camera
        b_neck_origin = geom.transform_points(np.zeros(3), base_H_neck)
        b_cam_origin = geom.transform_points(np.zeros(3), base_H_cam)
        m = markers.line_list('/BASE', ns, 7, 0.002, color, [b_neck_origin, b_cam_origin])
        self.viz.add(m)
        self.viz.update()

    def draw_transform(self, H, scale, ns, idnum):
        b_origin = geom.transform_points(np.array((0., 0., 0.)), H)
        b_ivec = geom.transform_vectors(np.array((1., 0., 0.)), H)
        b_jvec = geom.transform_vectors(np.array((0., 1., 0.)), H)
        b_kvec = geom.transform_vectors(np.array((0., 0., 1.)), H)
        m_list = markers.axes(
            '/BASE', ns, idnum, b_origin, b_ivec, b_jvec, b_kvec, scale, 0.05*scale)
        for m in m_list:
            self.viz.add(m)
        self.viz.update()

    def draw_observed_points(self, frame, cam_H_neck, ns, color, cam_mark_lines=False):
        cf_points = np.array([cf_p for (marker_i, cf_p) in frame.visible_markers])
        base_H_cam = np.dot(linalg.inv(frame.neck_H_base), linalg.inv(cam_H_neck))
        bf_points = geom.transform_points(cf_points, base_H_cam)
        m = markers.points('/BASE', ns, 0, 0.003, color, bf_points)
        self.viz.add(m)

        # draw lines from the camera to the points it sees
        if cam_mark_lines:
            bf_cam_origin = geom.transform_points(np.zeros(3), base_H_cam)
            line_points = []
            for bf_p in bf_points:
                line_points.append(bf_cam_origin)
                line_points.append(bf_p)
            m = markers.line_list('/BASE', ns, 7, 0.001, color, line_points)
            self.viz.add(m)
        
        self.viz.update()

    def draw_frames(self, frames, cam_H_neck, base_ns, color, cam_mark_lines=False):
        for f_i, f in enumerate(frames):
            self.draw_observed_points(f, cam_H_neck, '%s_%i_observed_points' % (base_ns, f_i), color, cam_mark_lines)
            self.draw_head_pose(f.neck_H_base, cam_H_neck, '%s_%i' % (base_ns, f_i), color)

    def update(self):
        self.viz.update()

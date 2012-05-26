; Auto-generated. Do not edit!


(cl:in-package ar_target-msg)


;//! \htmlinclude ARMarkers3d.msg.html

(cl:defclass <ARMarkers3d> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (markers
    :reader markers
    :initarg :markers
    :type (cl:vector ar_target-msg:ARMarker3d)
   :initform (cl:make-array 0 :element-type 'ar_target-msg:ARMarker3d :initial-element (cl:make-instance 'ar_target-msg:ARMarker3d))))
)

(cl:defclass ARMarkers3d (<ARMarkers3d>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <ARMarkers3d>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'ARMarkers3d)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name ar_target-msg:<ARMarkers3d> is deprecated: use ar_target-msg:ARMarkers3d instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <ARMarkers3d>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ar_target-msg:header-val is deprecated.  Use ar_target-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'markers-val :lambda-list '(m))
(cl:defmethod markers-val ((m <ARMarkers3d>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ar_target-msg:markers-val is deprecated.  Use ar_target-msg:markers instead.")
  (markers m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <ARMarkers3d>) ostream)
  "Serializes a message object of type '<ARMarkers3d>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'markers))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'markers))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <ARMarkers3d>) istream)
  "Deserializes a message object of type '<ARMarkers3d>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'markers) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'markers)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'ar_target-msg:ARMarker3d))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<ARMarkers3d>)))
  "Returns string type for a message object of type '<ARMarkers3d>"
  "ar_target/ARMarkers3d")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'ARMarkers3d)))
  "Returns string type for a message object of type 'ARMarkers3d"
  "ar_target/ARMarkers3d")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<ARMarkers3d>)))
  "Returns md5sum for a message object of type '<ARMarkers3d>"
  "e16e62abb0a52ea701e6449bd556c5d0")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'ARMarkers3d)))
  "Returns md5sum for a message object of type 'ARMarkers3d"
  "e16e62abb0a52ea701e6449bd556c5d0")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<ARMarkers3d>)))
  "Returns full string definition for message of type '<ARMarkers3d>"
  (cl:format cl:nil "Header header~%ar_target/ARMarker3d[] markers~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: ar_target/ARMarker3d~%int32 id~%float64 confidence~%float64[] left_u_corners~%float64[] left_v_corners~%float64[] right_u_corners~%float64[] right_v_corners~%geometry_msgs/Point[] corner_positions~%geometry_msgs/Quaternion[] corner_orientations~%geometry_msgs/Pose center_pose~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of postion and orientation. ~%Point position~%Quaternion orientation~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'ARMarkers3d)))
  "Returns full string definition for message of type 'ARMarkers3d"
  (cl:format cl:nil "Header header~%ar_target/ARMarker3d[] markers~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: ar_target/ARMarker3d~%int32 id~%float64 confidence~%float64[] left_u_corners~%float64[] left_v_corners~%float64[] right_u_corners~%float64[] right_v_corners~%geometry_msgs/Point[] corner_positions~%geometry_msgs/Quaternion[] corner_orientations~%geometry_msgs/Pose center_pose~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of postion and orientation. ~%Point position~%Quaternion orientation~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <ARMarkers3d>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'markers) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <ARMarkers3d>))
  "Converts a ROS message object to a list"
  (cl:list 'ARMarkers3d
    (cl:cons ':header (header msg))
    (cl:cons ':markers (markers msg))
))

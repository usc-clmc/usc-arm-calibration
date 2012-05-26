; Auto-generated. Do not edit!


(cl:in-package ar_pose-msg)


;//! \htmlinclude ARMarkers.msg.html

(cl:defclass <ARMarkers> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (markers
    :reader markers
    :initarg :markers
    :type (cl:vector ar_pose-msg:ARMarker)
   :initform (cl:make-array 0 :element-type 'ar_pose-msg:ARMarker :initial-element (cl:make-instance 'ar_pose-msg:ARMarker))))
)

(cl:defclass ARMarkers (<ARMarkers>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <ARMarkers>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'ARMarkers)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name ar_pose-msg:<ARMarkers> is deprecated: use ar_pose-msg:ARMarkers instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <ARMarkers>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ar_pose-msg:header-val is deprecated.  Use ar_pose-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'markers-val :lambda-list '(m))
(cl:defmethod markers-val ((m <ARMarkers>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader ar_pose-msg:markers-val is deprecated.  Use ar_pose-msg:markers instead.")
  (markers m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <ARMarkers>) ostream)
  "Serializes a message object of type '<ARMarkers>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'markers))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'markers))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <ARMarkers>) istream)
  "Deserializes a message object of type '<ARMarkers>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'markers) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'markers)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'ar_pose-msg:ARMarker))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<ARMarkers>)))
  "Returns string type for a message object of type '<ARMarkers>"
  "ar_pose/ARMarkers")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'ARMarkers)))
  "Returns string type for a message object of type 'ARMarkers"
  "ar_pose/ARMarkers")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<ARMarkers>)))
  "Returns md5sum for a message object of type '<ARMarkers>"
  "39a7f2e5f0eae4c86572d1aac1378022")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'ARMarkers)))
  "Returns md5sum for a message object of type 'ARMarkers"
  "39a7f2e5f0eae4c86572d1aac1378022")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<ARMarkers>)))
  "Returns full string definition for message of type '<ARMarkers>"
  (cl:format cl:nil "Header header~%ARMarker[] markers~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: ar_pose/ARMarker~%int32 id~%float64 confidence~%geometry_msgs/Quaternion quaternion~%float64[] u_corners~%float64[] v_corners~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'ARMarkers)))
  "Returns full string definition for message of type 'ARMarkers"
  (cl:format cl:nil "Header header~%ARMarker[] markers~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: ar_pose/ARMarker~%int32 id~%float64 confidence~%geometry_msgs/Quaternion quaternion~%float64[] u_corners~%float64[] v_corners~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <ARMarkers>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'markers) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <ARMarkers>))
  "Converts a ROS message object to a list"
  (cl:list 'ARMarkers
    (cl:cons ':header (header msg))
    (cl:cons ':markers (markers msg))
))

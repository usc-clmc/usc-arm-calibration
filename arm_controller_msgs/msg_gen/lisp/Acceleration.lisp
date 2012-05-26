; Auto-generated. Do not edit!


(cl:in-package arm_controller_msgs-msg)


;//! \htmlinclude Acceleration.msg.html

(cl:defclass <Acceleration> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (acceleration
    :reader acceleration
    :initarg :acceleration
    :type (cl:vector cl:float)
   :initform (cl:make-array 3 :element-type 'cl:float :initial-element 0.0)))
)

(cl:defclass Acceleration (<Acceleration>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Acceleration>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Acceleration)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-msg:<Acceleration> is deprecated: use arm_controller_msgs-msg:Acceleration instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <Acceleration>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:header-val is deprecated.  Use arm_controller_msgs-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'acceleration-val :lambda-list '(m))
(cl:defmethod acceleration-val ((m <Acceleration>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:acceleration-val is deprecated.  Use arm_controller_msgs-msg:acceleration instead.")
  (acceleration m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<Acceleration>)))
    "Constants for message type '<Acceleration>"
  '((:ACC_X . 0)
    (:ACC_Y . 1)
    (:ACC_Z . 2))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'Acceleration)))
    "Constants for message type 'Acceleration"
  '((:ACC_X . 0)
    (:ACC_Y . 1)
    (:ACC_Z . 2))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Acceleration>) ostream)
  "Serializes a message object of type '<Acceleration>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'acceleration))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Acceleration>) istream)
  "Deserializes a message object of type '<Acceleration>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  (cl:setf (cl:slot-value msg 'acceleration) (cl:make-array 3))
  (cl:let ((vals (cl:slot-value msg 'acceleration)))
    (cl:dotimes (i 3)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:aref vals i) (roslisp-utils:decode-double-float-bits bits)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Acceleration>)))
  "Returns string type for a message object of type '<Acceleration>"
  "arm_controller_msgs/Acceleration")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Acceleration)))
  "Returns string type for a message object of type 'Acceleration"
  "arm_controller_msgs/Acceleration")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Acceleration>)))
  "Returns md5sum for a message object of type '<Acceleration>"
  "ee6895ce67b7feb67d4d61b2d2654d26")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Acceleration)))
  "Returns md5sum for a message object of type 'Acceleration"
  "ee6895ce67b7feb67d4d61b2d2654d26")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Acceleration>)))
  "Returns full string definition for message of type '<Acceleration>"
  (cl:format cl:nil "# Standard ROS header~%Header header~%~%# Acceleration values in ACC_X, ACC_Y, ACC_Z, in m/s^2~%float64[3] acceleration~%~%# constants for indexing into the above array~%int32 ACC_X=0~%int32 ACC_Y=1~%int32 ACC_Z=2~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Acceleration)))
  "Returns full string definition for message of type 'Acceleration"
  (cl:format cl:nil "# Standard ROS header~%Header header~%~%# Acceleration values in ACC_X, ACC_Y, ACC_Z, in m/s^2~%float64[3] acceleration~%~%# constants for indexing into the above array~%int32 ACC_X=0~%int32 ACC_Y=1~%int32 ACC_Z=2~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Acceleration>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'acceleration) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Acceleration>))
  "Converts a ROS message object to a list"
  (cl:list 'Acceleration
    (cl:cons ':header (header msg))
    (cl:cons ':acceleration (acceleration msg))
))

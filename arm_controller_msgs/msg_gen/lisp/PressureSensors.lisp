; Auto-generated. Do not edit!


(cl:in-package arm_controller_msgs-msg)


;//! \htmlinclude PressureSensors.msg.html

(cl:defclass <PressureSensors> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (palm
    :reader palm
    :initarg :palm
    :type (cl:vector cl:float)
   :initform (cl:make-array 24 :element-type 'cl:float :initial-element 0.0))
   (right_finger
    :reader right_finger
    :initarg :right_finger
    :type (cl:vector cl:float)
   :initform (cl:make-array 24 :element-type 'cl:float :initial-element 0.0))
   (middle_finger
    :reader middle_finger
    :initarg :middle_finger
    :type (cl:vector cl:float)
   :initform (cl:make-array 24 :element-type 'cl:float :initial-element 0.0))
   (left_finger
    :reader left_finger
    :initarg :left_finger
    :type (cl:vector cl:float)
   :initform (cl:make-array 24 :element-type 'cl:float :initial-element 0.0)))
)

(cl:defclass PressureSensors (<PressureSensors>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <PressureSensors>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'PressureSensors)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-msg:<PressureSensors> is deprecated: use arm_controller_msgs-msg:PressureSensors instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <PressureSensors>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:header-val is deprecated.  Use arm_controller_msgs-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'palm-val :lambda-list '(m))
(cl:defmethod palm-val ((m <PressureSensors>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:palm-val is deprecated.  Use arm_controller_msgs-msg:palm instead.")
  (palm m))

(cl:ensure-generic-function 'right_finger-val :lambda-list '(m))
(cl:defmethod right_finger-val ((m <PressureSensors>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:right_finger-val is deprecated.  Use arm_controller_msgs-msg:right_finger instead.")
  (right_finger m))

(cl:ensure-generic-function 'middle_finger-val :lambda-list '(m))
(cl:defmethod middle_finger-val ((m <PressureSensors>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:middle_finger-val is deprecated.  Use arm_controller_msgs-msg:middle_finger instead.")
  (middle_finger m))

(cl:ensure-generic-function 'left_finger-val :lambda-list '(m))
(cl:defmethod left_finger-val ((m <PressureSensors>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:left_finger-val is deprecated.  Use arm_controller_msgs-msg:left_finger instead.")
  (left_finger m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<PressureSensors>)))
    "Constants for message type '<PressureSensors>"
  '((:NUM_PRESSURE_CELLS_PER_ARRAY . 24))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'PressureSensors)))
    "Constants for message type 'PressureSensors"
  '((:NUM_PRESSURE_CELLS_PER_ARRAY . 24))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <PressureSensors>) ostream)
  "Serializes a message object of type '<PressureSensors>"
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
   (cl:slot-value msg 'palm))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'right_finger))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'middle_finger))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'left_finger))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <PressureSensors>) istream)
  "Deserializes a message object of type '<PressureSensors>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  (cl:setf (cl:slot-value msg 'palm) (cl:make-array 24))
  (cl:let ((vals (cl:slot-value msg 'palm)))
    (cl:dotimes (i 24)
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
  (cl:setf (cl:slot-value msg 'right_finger) (cl:make-array 24))
  (cl:let ((vals (cl:slot-value msg 'right_finger)))
    (cl:dotimes (i 24)
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
  (cl:setf (cl:slot-value msg 'middle_finger) (cl:make-array 24))
  (cl:let ((vals (cl:slot-value msg 'middle_finger)))
    (cl:dotimes (i 24)
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
  (cl:setf (cl:slot-value msg 'left_finger) (cl:make-array 24))
  (cl:let ((vals (cl:slot-value msg 'left_finger)))
    (cl:dotimes (i 24)
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
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<PressureSensors>)))
  "Returns string type for a message object of type '<PressureSensors>"
  "arm_controller_msgs/PressureSensors")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'PressureSensors)))
  "Returns string type for a message object of type 'PressureSensors"
  "arm_controller_msgs/PressureSensors")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<PressureSensors>)))
  "Returns md5sum for a message object of type '<PressureSensors>"
  "55551820909b04a2ce8b9d662963e448")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'PressureSensors)))
  "Returns md5sum for a message object of type 'PressureSensors"
  "55551820909b04a2ce8b9d662963e448")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<PressureSensors>)))
  "Returns full string definition for message of type '<PressureSensors>"
  (cl:format cl:nil "# message containing the pressure information~%~%# Standard ROS header~%Header header~%~%# each an array of 24 touch values~%int32 NUM_PRESSURE_CELLS_PER_ARRAY=24~%~%# each an array of 24 touch values~%float64[24] palm~%float64[24] right_finger~%float64[24] middle_finger~%float64[24] left_finger~%~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'PressureSensors)))
  "Returns full string definition for message of type 'PressureSensors"
  (cl:format cl:nil "# message containing the pressure information~%~%# Standard ROS header~%Header header~%~%# each an array of 24 touch values~%int32 NUM_PRESSURE_CELLS_PER_ARRAY=24~%~%# each an array of 24 touch values~%float64[24] palm~%float64[24] right_finger~%float64[24] middle_finger~%float64[24] left_finger~%~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <PressureSensors>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'palm) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'right_finger) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'middle_finger) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'left_finger) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <PressureSensors>))
  "Converts a ROS message object to a list"
  (cl:list 'PressureSensors
    (cl:cons ':header (header msg))
    (cl:cons ':palm (palm msg))
    (cl:cons ':right_finger (right_finger msg))
    (cl:cons ':middle_finger (middle_finger msg))
    (cl:cons ':left_finger (left_finger msg))
))

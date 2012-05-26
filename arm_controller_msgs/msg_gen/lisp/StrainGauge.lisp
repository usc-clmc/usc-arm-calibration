; Auto-generated. Do not edit!


(cl:in-package arm_controller_msgs-msg)


;//! \htmlinclude StrainGauge.msg.html

(cl:defclass <StrainGauge> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (torque
    :reader torque
    :initarg :torque
    :type (cl:vector cl:float)
   :initform (cl:make-array 0 :element-type 'cl:float :initial-element 0.0)))
)

(cl:defclass StrainGauge (<StrainGauge>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <StrainGauge>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'StrainGauge)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-msg:<StrainGauge> is deprecated: use arm_controller_msgs-msg:StrainGauge instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <StrainGauge>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:header-val is deprecated.  Use arm_controller_msgs-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'torque-val :lambda-list '(m))
(cl:defmethod torque-val ((m <StrainGauge>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:torque-val is deprecated.  Use arm_controller_msgs-msg:torque instead.")
  (torque m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<StrainGauge>)))
    "Constants for message type '<StrainGauge>"
  '((:R_RF . 0)
    (:R_MF . 1)
    (:R_LF . 2)
    (:L_RF . 0)
    (:L_MF . 1)
    (:L_LF . 2)
    (:RF . 0)
    (:MF . 1)
    (:LF . 2))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'StrainGauge)))
    "Constants for message type 'StrainGauge"
  '((:R_RF . 0)
    (:R_MF . 1)
    (:R_LF . 2)
    (:L_RF . 0)
    (:L_MF . 1)
    (:L_LF . 2)
    (:RF . 0)
    (:MF . 1)
    (:LF . 2))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <StrainGauge>) ostream)
  "Serializes a message object of type '<StrainGauge>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'torque))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'torque))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <StrainGauge>) istream)
  "Deserializes a message object of type '<StrainGauge>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'torque) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'torque)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:aref vals i) (roslisp-utils:decode-double-float-bits bits))))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<StrainGauge>)))
  "Returns string type for a message object of type '<StrainGauge>"
  "arm_controller_msgs/StrainGauge")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'StrainGauge)))
  "Returns string type for a message object of type 'StrainGauge"
  "arm_controller_msgs/StrainGauge")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<StrainGauge>)))
  "Returns md5sum for a message object of type '<StrainGauge>"
  "459ae124b5743ba86496f42e542c416e")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'StrainGauge)))
  "Returns md5sum for a message object of type 'StrainGauge"
  "459ae124b5743ba86496f42e542c416e")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<StrainGauge>)))
  "Returns full string definition for message of type '<StrainGauge>"
  (cl:format cl:nil "# Standard ROS header~%Header header~%~%# Three torque values, one per finger, in Nm~%float64[] torque~%~%# constants for indexing into the above array~%int32 R_RF=0~%int32 R_MF=1~%int32 R_LF=2~%int32 L_RF=0~%int32 L_MF=1~%int32 L_LF=2~%int32 RF=0~%int32 MF=1~%int32 LF=2~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'StrainGauge)))
  "Returns full string definition for message of type 'StrainGauge"
  (cl:format cl:nil "# Standard ROS header~%Header header~%~%# Three torque values, one per finger, in Nm~%float64[] torque~%~%# constants for indexing into the above array~%int32 R_RF=0~%int32 R_MF=1~%int32 R_LF=2~%int32 L_RF=0~%int32 L_MF=1~%int32 L_LF=2~%int32 RF=0~%int32 MF=1~%int32 LF=2~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <StrainGauge>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'torque) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <StrainGauge>))
  "Converts a ROS message object to a list"
  (cl:list 'StrainGauge
    (cl:cons ':header (header msg))
    (cl:cons ':torque (torque msg))
))

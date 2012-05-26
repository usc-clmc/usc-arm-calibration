; Auto-generated. Do not edit!


(cl:in-package arm_controller_msgs-msg)


;//! \htmlinclude FingerForceControlGains.msg.html

(cl:defclass <FingerForceControlGains> (roslisp-msg-protocol:ros-message)
  ((p_gains
    :reader p_gains
    :initarg :p_gains
    :type (cl:vector cl:float)
   :initform (cl:make-array 3 :element-type 'cl:float :initial-element 0.0))
   (i_gains
    :reader i_gains
    :initarg :i_gains
    :type (cl:vector cl:float)
   :initform (cl:make-array 3 :element-type 'cl:float :initial-element 0.0)))
)

(cl:defclass FingerForceControlGains (<FingerForceControlGains>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <FingerForceControlGains>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'FingerForceControlGains)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-msg:<FingerForceControlGains> is deprecated: use arm_controller_msgs-msg:FingerForceControlGains instead.")))

(cl:ensure-generic-function 'p_gains-val :lambda-list '(m))
(cl:defmethod p_gains-val ((m <FingerForceControlGains>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:p_gains-val is deprecated.  Use arm_controller_msgs-msg:p_gains instead.")
  (p_gains m))

(cl:ensure-generic-function 'i_gains-val :lambda-list '(m))
(cl:defmethod i_gains-val ((m <FingerForceControlGains>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:i_gains-val is deprecated.  Use arm_controller_msgs-msg:i_gains instead.")
  (i_gains m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<FingerForceControlGains>)))
    "Constants for message type '<FingerForceControlGains>"
  '((:R_RF . 0)
    (:R_MF . 1)
    (:R_LF . 2))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'FingerForceControlGains)))
    "Constants for message type 'FingerForceControlGains"
  '((:R_RF . 0)
    (:R_MF . 1)
    (:R_LF . 2))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <FingerForceControlGains>) ostream)
  "Serializes a message object of type '<FingerForceControlGains>"
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'p_gains))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'i_gains))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <FingerForceControlGains>) istream)
  "Deserializes a message object of type '<FingerForceControlGains>"
  (cl:setf (cl:slot-value msg 'p_gains) (cl:make-array 3))
  (cl:let ((vals (cl:slot-value msg 'p_gains)))
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
  (cl:setf (cl:slot-value msg 'i_gains) (cl:make-array 3))
  (cl:let ((vals (cl:slot-value msg 'i_gains)))
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
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<FingerForceControlGains>)))
  "Returns string type for a message object of type '<FingerForceControlGains>"
  "arm_controller_msgs/FingerForceControlGains")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'FingerForceControlGains)))
  "Returns string type for a message object of type 'FingerForceControlGains"
  "arm_controller_msgs/FingerForceControlGains")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<FingerForceControlGains>)))
  "Returns md5sum for a message object of type '<FingerForceControlGains>"
  "ec04ae7deaf29fbb1d9de2ef2606c3cc")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'FingerForceControlGains)))
  "Returns md5sum for a message object of type 'FingerForceControlGains"
  "ec04ae7deaf29fbb1d9de2ef2606c3cc")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<FingerForceControlGains>)))
  "Returns full string definition for message of type '<FingerForceControlGains>"
  (cl:format cl:nil "float64[3] p_gains~%float64[3] i_gains~%~%# constants for indexing into the above array~%int32 R_RF=0~%int32 R_MF=1~%int32 R_LF=2~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'FingerForceControlGains)))
  "Returns full string definition for message of type 'FingerForceControlGains"
  (cl:format cl:nil "float64[3] p_gains~%float64[3] i_gains~%~%# constants for indexing into the above array~%int32 R_RF=0~%int32 R_MF=1~%int32 R_LF=2~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <FingerForceControlGains>))
  (cl:+ 0
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'p_gains) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'i_gains) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <FingerForceControlGains>))
  "Converts a ROS message object to a list"
  (cl:list 'FingerForceControlGains
    (cl:cons ':p_gains (p_gains msg))
    (cl:cons ':i_gains (i_gains msg))
))

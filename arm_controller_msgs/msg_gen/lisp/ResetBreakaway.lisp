; Auto-generated. Do not edit!


(cl:in-package arm_controller_msgs-msg)


;//! \htmlinclude ResetBreakaway.msg.html

(cl:defclass <ResetBreakaway> (roslisp-msg-protocol:ros-message)
  ((fingers
    :reader fingers
    :initarg :fingers
    :type cl:integer
    :initform 0)
   (fast_reset
    :reader fast_reset
    :initarg :fast_reset
    :type cl:boolean
    :initform cl:nil))
)

(cl:defclass ResetBreakaway (<ResetBreakaway>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <ResetBreakaway>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'ResetBreakaway)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-msg:<ResetBreakaway> is deprecated: use arm_controller_msgs-msg:ResetBreakaway instead.")))

(cl:ensure-generic-function 'fingers-val :lambda-list '(m))
(cl:defmethod fingers-val ((m <ResetBreakaway>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:fingers-val is deprecated.  Use arm_controller_msgs-msg:fingers instead.")
  (fingers m))

(cl:ensure-generic-function 'fast_reset-val :lambda-list '(m))
(cl:defmethod fast_reset-val ((m <ResetBreakaway>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:fast_reset-val is deprecated.  Use arm_controller_msgs-msg:fast_reset instead.")
  (fast_reset m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<ResetBreakaway>)))
    "Constants for message type '<ResetBreakaway>"
  '((:R_RF . 1)
    (:R_MF . 2)
    (:R_LF . 4)
    (:ALL_FINGERS . 7))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'ResetBreakaway)))
    "Constants for message type 'ResetBreakaway"
  '((:R_RF . 1)
    (:R_MF . 2)
    (:R_LF . 4)
    (:ALL_FINGERS . 7))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <ResetBreakaway>) ostream)
  "Serializes a message object of type '<ResetBreakaway>"
  (cl:let* ((signed (cl:slot-value msg 'fingers)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'fast_reset) 1 0)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <ResetBreakaway>) istream)
  "Deserializes a message object of type '<ResetBreakaway>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'fingers) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:setf (cl:slot-value msg 'fast_reset) (cl:not (cl:zerop (cl:read-byte istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<ResetBreakaway>)))
  "Returns string type for a message object of type '<ResetBreakaway>"
  "arm_controller_msgs/ResetBreakaway")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'ResetBreakaway)))
  "Returns string type for a message object of type 'ResetBreakaway"
  "arm_controller_msgs/ResetBreakaway")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<ResetBreakaway>)))
  "Returns md5sum for a message object of type '<ResetBreakaway>"
  "0f220a14db48a0cdca2e24fac2f89341")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'ResetBreakaway)))
  "Returns md5sum for a message object of type 'ResetBreakaway"
  "0f220a14db48a0cdca2e24fac2f89341")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<ResetBreakaway>)))
  "Returns full string definition for message of type '<ResetBreakaway>"
  (cl:format cl:nil "# empty message to reset breakaway~%int32 fingers~%bool fast_reset~%~%int32 R_RF=1~%int32 R_MF=2~%int32 R_LF=4~%int32 ALL_FINGERS=7~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'ResetBreakaway)))
  "Returns full string definition for message of type 'ResetBreakaway"
  (cl:format cl:nil "# empty message to reset breakaway~%int32 fingers~%bool fast_reset~%~%int32 R_RF=1~%int32 R_MF=2~%int32 R_LF=4~%int32 ALL_FINGERS=7~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <ResetBreakaway>))
  (cl:+ 0
     4
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <ResetBreakaway>))
  "Converts a ROS message object to a list"
  (cl:list 'ResetBreakaway
    (cl:cons ':fingers (fingers msg))
    (cl:cons ':fast_reset (fast_reset msg))
))

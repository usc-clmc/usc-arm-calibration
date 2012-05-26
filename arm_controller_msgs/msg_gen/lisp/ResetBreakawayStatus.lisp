; Auto-generated. Do not edit!


(cl:in-package arm_controller_msgs-msg)


;//! \htmlinclude ResetBreakawayStatus.msg.html

(cl:defclass <ResetBreakawayStatus> (roslisp-msg-protocol:ros-message)
  ((status
    :reader status
    :initarg :status
    :type cl:integer
    :initform 0))
)

(cl:defclass ResetBreakawayStatus (<ResetBreakawayStatus>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <ResetBreakawayStatus>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'ResetBreakawayStatus)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-msg:<ResetBreakawayStatus> is deprecated: use arm_controller_msgs-msg:ResetBreakawayStatus instead.")))

(cl:ensure-generic-function 'status-val :lambda-list '(m))
(cl:defmethod status-val ((m <ResetBreakawayStatus>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:status-val is deprecated.  Use arm_controller_msgs-msg:status instead.")
  (status m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<ResetBreakawayStatus>)))
    "Constants for message type '<ResetBreakawayStatus>"
  '((:SUCCEEDED . 1)
    (:FAILED . 2))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'ResetBreakawayStatus)))
    "Constants for message type 'ResetBreakawayStatus"
  '((:SUCCEEDED . 1)
    (:FAILED . 2))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <ResetBreakawayStatus>) ostream)
  "Serializes a message object of type '<ResetBreakawayStatus>"
  (cl:let* ((signed (cl:slot-value msg 'status)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <ResetBreakawayStatus>) istream)
  "Deserializes a message object of type '<ResetBreakawayStatus>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'status) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<ResetBreakawayStatus>)))
  "Returns string type for a message object of type '<ResetBreakawayStatus>"
  "arm_controller_msgs/ResetBreakawayStatus")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'ResetBreakawayStatus)))
  "Returns string type for a message object of type 'ResetBreakawayStatus"
  "arm_controller_msgs/ResetBreakawayStatus")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<ResetBreakawayStatus>)))
  "Returns md5sum for a message object of type '<ResetBreakawayStatus>"
  "20d60c7fb0f1fa468f9a953f3e851e39")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'ResetBreakawayStatus)))
  "Returns md5sum for a message object of type 'ResetBreakawayStatus"
  "20d60c7fb0f1fa468f9a953f3e851e39")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<ResetBreakawayStatus>)))
  "Returns full string definition for message of type '<ResetBreakawayStatus>"
  (cl:format cl:nil "#answer with a success or failure / used to detect if the fingers are stuck~%int32 status~%~%~%# Possible types of status~%int32 SUCCEEDED=1~%int32 FAILED=2~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'ResetBreakawayStatus)))
  "Returns full string definition for message of type 'ResetBreakawayStatus"
  (cl:format cl:nil "#answer with a success or failure / used to detect if the fingers are stuck~%int32 status~%~%~%# Possible types of status~%int32 SUCCEEDED=1~%int32 FAILED=2~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <ResetBreakawayStatus>))
  (cl:+ 0
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <ResetBreakawayStatus>))
  "Converts a ROS message object to a list"
  (cl:list 'ResetBreakawayStatus
    (cl:cons ':status (status msg))
))

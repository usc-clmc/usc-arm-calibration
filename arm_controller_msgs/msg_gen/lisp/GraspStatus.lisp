; Auto-generated. Do not edit!


(cl:in-package arm_controller_msgs-msg)


;//! \htmlinclude GraspStatus.msg.html

(cl:defclass <GraspStatus> (roslisp-msg-protocol:ros-message)
  ((status
    :reader status
    :initarg :status
    :type cl:integer
    :initform 0))
)

(cl:defclass GraspStatus (<GraspStatus>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <GraspStatus>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'GraspStatus)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-msg:<GraspStatus> is deprecated: use arm_controller_msgs-msg:GraspStatus instead.")))

(cl:ensure-generic-function 'status-val :lambda-list '(m))
(cl:defmethod status-val ((m <GraspStatus>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:status-val is deprecated.  Use arm_controller_msgs-msg:status instead.")
  (status m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<GraspStatus>)))
    "Constants for message type '<GraspStatus>"
  '((:GRASP_SUCCEEDED . 1)
    (:GRASP_FAILED . 2)
    (:RELEASE_SUCCEEDED . 3)
    (:RELEASE_FAILED . 4)
    (:HOLDING_FAILED . 5))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'GraspStatus)))
    "Constants for message type 'GraspStatus"
  '((:GRASP_SUCCEEDED . 1)
    (:GRASP_FAILED . 2)
    (:RELEASE_SUCCEEDED . 3)
    (:RELEASE_FAILED . 4)
    (:HOLDING_FAILED . 5))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <GraspStatus>) ostream)
  "Serializes a message object of type '<GraspStatus>"
  (cl:let* ((signed (cl:slot-value msg 'status)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <GraspStatus>) istream)
  "Deserializes a message object of type '<GraspStatus>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'status) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<GraspStatus>)))
  "Returns string type for a message object of type '<GraspStatus>"
  "arm_controller_msgs/GraspStatus")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'GraspStatus)))
  "Returns string type for a message object of type 'GraspStatus"
  "arm_controller_msgs/GraspStatus")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<GraspStatus>)))
  "Returns md5sum for a message object of type '<GraspStatus>"
  "6c6016937bbcb3fca485c1a9ec5b1493")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'GraspStatus)))
  "Returns md5sum for a message object of type 'GraspStatus"
  "6c6016937bbcb3fca485c1a9ec5b1493")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<GraspStatus>)))
  "Returns full string definition for message of type '<GraspStatus>"
  (cl:format cl:nil "# Status~%int32 status~%~%# Possible types of status~%int32 GRASP_SUCCEEDED=1~%int32 GRASP_FAILED=2~%int32 RELEASE_SUCCEEDED=3~%int32 RELEASE_FAILED=4~%int32 HOLDING_FAILED=5~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'GraspStatus)))
  "Returns full string definition for message of type 'GraspStatus"
  (cl:format cl:nil "# Status~%int32 status~%~%# Possible types of status~%int32 GRASP_SUCCEEDED=1~%int32 GRASP_FAILED=2~%int32 RELEASE_SUCCEEDED=3~%int32 RELEASE_FAILED=4~%int32 HOLDING_FAILED=5~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <GraspStatus>))
  (cl:+ 0
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <GraspStatus>))
  "Converts a ROS message object to a list"
  (cl:list 'GraspStatus
    (cl:cons ':status (status msg))
))

; Auto-generated. Do not edit!


(cl:in-package arm_behavior_actions-msg)


;//! \htmlinclude ManipulateObjectResult.msg.html

(cl:defclass <ManipulateObjectResult> (roslisp-msg-protocol:ros-message)
  ((result
    :reader result
    :initarg :result
    :type cl:integer
    :initform 0)
   (target
    :reader target
    :initarg :target
    :type geometry_msgs-msg:Point
    :initform (cl:make-instance 'geometry_msgs-msg:Point))
   (yaw_diff
    :reader yaw_diff
    :initarg :yaw_diff
    :type cl:float
    :initform 0.0))
)

(cl:defclass ManipulateObjectResult (<ManipulateObjectResult>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <ManipulateObjectResult>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'ManipulateObjectResult)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_behavior_actions-msg:<ManipulateObjectResult> is deprecated: use arm_behavior_actions-msg:ManipulateObjectResult instead.")))

(cl:ensure-generic-function 'result-val :lambda-list '(m))
(cl:defmethod result-val ((m <ManipulateObjectResult>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_behavior_actions-msg:result-val is deprecated.  Use arm_behavior_actions-msg:result instead.")
  (result m))

(cl:ensure-generic-function 'target-val :lambda-list '(m))
(cl:defmethod target-val ((m <ManipulateObjectResult>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_behavior_actions-msg:target-val is deprecated.  Use arm_behavior_actions-msg:target instead.")
  (target m))

(cl:ensure-generic-function 'yaw_diff-val :lambda-list '(m))
(cl:defmethod yaw_diff-val ((m <ManipulateObjectResult>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_behavior_actions-msg:yaw_diff-val is deprecated.  Use arm_behavior_actions-msg:yaw_diff instead.")
  (yaw_diff m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<ManipulateObjectResult>)))
    "Constants for message type '<ManipulateObjectResult>"
  '((:FAILED . 0)
    (:SUCCEEDED . 1)
    (:REPOSITION . 2)
    (:RETRY . 3)
    (:PREEMPTED . 4))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'ManipulateObjectResult)))
    "Constants for message type 'ManipulateObjectResult"
  '((:FAILED . 0)
    (:SUCCEEDED . 1)
    (:REPOSITION . 2)
    (:RETRY . 3)
    (:PREEMPTED . 4))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <ManipulateObjectResult>) ostream)
  "Serializes a message object of type '<ManipulateObjectResult>"
  (cl:let* ((signed (cl:slot-value msg 'result)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'target) ostream)
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'yaw_diff))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <ManipulateObjectResult>) istream)
  "Deserializes a message object of type '<ManipulateObjectResult>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'result) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'target) istream)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'yaw_diff) (roslisp-utils:decode-double-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<ManipulateObjectResult>)))
  "Returns string type for a message object of type '<ManipulateObjectResult>"
  "arm_behavior_actions/ManipulateObjectResult")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'ManipulateObjectResult)))
  "Returns string type for a message object of type 'ManipulateObjectResult"
  "arm_behavior_actions/ManipulateObjectResult")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<ManipulateObjectResult>)))
  "Returns md5sum for a message object of type '<ManipulateObjectResult>"
  "11ebc03fc6d1f8fb0be73d02b65902ff")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'ManipulateObjectResult)))
  "Returns md5sum for a message object of type 'ManipulateObjectResult"
  "11ebc03fc6d1f8fb0be73d02b65902ff")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<ManipulateObjectResult>)))
  "Returns full string definition for message of type '<ManipulateObjectResult>"
  (cl:format cl:nil "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======~%int32 result~%int32 FAILED=0~%int32 SUCCEEDED=1~%~%# Used for drill repositioning:~%int32 REPOSITION=2~%int32 RETRY=3~%geometry_msgs/Point target~%float64 yaw_diff~%~%# Result if preempted~%int32 PREEMPTED=4~%~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'ManipulateObjectResult)))
  "Returns full string definition for message of type 'ManipulateObjectResult"
  (cl:format cl:nil "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======~%int32 result~%int32 FAILED=0~%int32 SUCCEEDED=1~%~%# Used for drill repositioning:~%int32 REPOSITION=2~%int32 RETRY=3~%geometry_msgs/Point target~%float64 yaw_diff~%~%# Result if preempted~%int32 PREEMPTED=4~%~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <ManipulateObjectResult>))
  (cl:+ 0
     4
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'target))
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <ManipulateObjectResult>))
  "Converts a ROS message object to a list"
  (cl:list 'ManipulateObjectResult
    (cl:cons ':result (result msg))
    (cl:cons ':target (target msg))
    (cl:cons ':yaw_diff (yaw_diff msg))
))

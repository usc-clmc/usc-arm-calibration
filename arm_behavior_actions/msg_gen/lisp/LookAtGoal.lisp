; Auto-generated. Do not edit!


(cl:in-package arm_behavior_actions-msg)


;//! \htmlinclude LookAtGoal.msg.html

(cl:defclass <LookAtGoal> (roslisp-msg-protocol:ros-message)
  ((pos
    :reader pos
    :initarg :pos
    :type geometry_msgs-msg:Point
    :initform (cl:make-instance 'geometry_msgs-msg:Point))
   (lower_pan
    :reader lower_pan
    :initarg :lower_pan
    :type cl:float
    :initform 0.0)
   (lower_tilt
    :reader lower_tilt
    :initarg :lower_tilt
    :type cl:float
    :initform 0.0))
)

(cl:defclass LookAtGoal (<LookAtGoal>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <LookAtGoal>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'LookAtGoal)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_behavior_actions-msg:<LookAtGoal> is deprecated: use arm_behavior_actions-msg:LookAtGoal instead.")))

(cl:ensure-generic-function 'pos-val :lambda-list '(m))
(cl:defmethod pos-val ((m <LookAtGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_behavior_actions-msg:pos-val is deprecated.  Use arm_behavior_actions-msg:pos instead.")
  (pos m))

(cl:ensure-generic-function 'lower_pan-val :lambda-list '(m))
(cl:defmethod lower_pan-val ((m <LookAtGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_behavior_actions-msg:lower_pan-val is deprecated.  Use arm_behavior_actions-msg:lower_pan instead.")
  (lower_pan m))

(cl:ensure-generic-function 'lower_tilt-val :lambda-list '(m))
(cl:defmethod lower_tilt-val ((m <LookAtGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_behavior_actions-msg:lower_tilt-val is deprecated.  Use arm_behavior_actions-msg:lower_tilt instead.")
  (lower_tilt m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <LookAtGoal>) ostream)
  "Serializes a message object of type '<LookAtGoal>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'pos) ostream)
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'lower_pan))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'lower_tilt))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <LookAtGoal>) istream)
  "Deserializes a message object of type '<LookAtGoal>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'pos) istream)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'lower_pan) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'lower_tilt) (roslisp-utils:decode-double-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<LookAtGoal>)))
  "Returns string type for a message object of type '<LookAtGoal>"
  "arm_behavior_actions/LookAtGoal")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'LookAtGoal)))
  "Returns string type for a message object of type 'LookAtGoal"
  "arm_behavior_actions/LookAtGoal")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<LookAtGoal>)))
  "Returns md5sum for a message object of type '<LookAtGoal>"
  "e285967859f3b4649938b636f17ac061")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'LookAtGoal)))
  "Returns md5sum for a message object of type 'LookAtGoal"
  "e285967859f3b4649938b636f17ac061")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<LookAtGoal>)))
  "Returns full string definition for message of type '<LookAtGoal>"
  (cl:format cl:nil "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======~%# Define the goal~%geometry_msgs/Point pos~%float64 lower_pan~%float64 lower_tilt~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'LookAtGoal)))
  "Returns full string definition for message of type 'LookAtGoal"
  (cl:format cl:nil "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======~%# Define the goal~%geometry_msgs/Point pos~%float64 lower_pan~%float64 lower_tilt~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <LookAtGoal>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'pos))
     8
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <LookAtGoal>))
  "Converts a ROS message object to a list"
  (cl:list 'LookAtGoal
    (cl:cons ':pos (pos msg))
    (cl:cons ':lower_pan (lower_pan msg))
    (cl:cons ':lower_tilt (lower_tilt msg))
))

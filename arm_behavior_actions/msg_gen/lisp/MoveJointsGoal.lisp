; Auto-generated. Do not edit!


(cl:in-package arm_behavior_actions-msg)


;//! \htmlinclude MoveJointsGoal.msg.html

(cl:defclass <MoveJointsGoal> (roslisp-msg-protocol:ros-message)
  ((positions
    :reader positions
    :initarg :positions
    :type (cl:vector cl:float)
   :initform (cl:make-array 0 :element-type 'cl:float :initial-element 0.0))
   (time
    :reader time
    :initarg :time
    :type cl:float
    :initform 0.0)
   (auto_generate_time
    :reader auto_generate_time
    :initarg :auto_generate_time
    :type cl:boolean
    :initform cl:nil))
)

(cl:defclass MoveJointsGoal (<MoveJointsGoal>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <MoveJointsGoal>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'MoveJointsGoal)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_behavior_actions-msg:<MoveJointsGoal> is deprecated: use arm_behavior_actions-msg:MoveJointsGoal instead.")))

(cl:ensure-generic-function 'positions-val :lambda-list '(m))
(cl:defmethod positions-val ((m <MoveJointsGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_behavior_actions-msg:positions-val is deprecated.  Use arm_behavior_actions-msg:positions instead.")
  (positions m))

(cl:ensure-generic-function 'time-val :lambda-list '(m))
(cl:defmethod time-val ((m <MoveJointsGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_behavior_actions-msg:time-val is deprecated.  Use arm_behavior_actions-msg:time instead.")
  (time m))

(cl:ensure-generic-function 'auto_generate_time-val :lambda-list '(m))
(cl:defmethod auto_generate_time-val ((m <MoveJointsGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_behavior_actions-msg:auto_generate_time-val is deprecated.  Use arm_behavior_actions-msg:auto_generate_time instead.")
  (auto_generate_time m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <MoveJointsGoal>) ostream)
  "Serializes a message object of type '<MoveJointsGoal>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'positions))))
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
   (cl:slot-value msg 'positions))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'time))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'auto_generate_time) 1 0)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <MoveJointsGoal>) istream)
  "Deserializes a message object of type '<MoveJointsGoal>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'positions) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'positions)))
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
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'time) (roslisp-utils:decode-double-float-bits bits)))
    (cl:setf (cl:slot-value msg 'auto_generate_time) (cl:not (cl:zerop (cl:read-byte istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<MoveJointsGoal>)))
  "Returns string type for a message object of type '<MoveJointsGoal>"
  "arm_behavior_actions/MoveJointsGoal")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'MoveJointsGoal)))
  "Returns string type for a message object of type 'MoveJointsGoal"
  "arm_behavior_actions/MoveJointsGoal")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<MoveJointsGoal>)))
  "Returns md5sum for a message object of type '<MoveJointsGoal>"
  "657e3cbd4c41f25661ff55f41f7bf2cf")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'MoveJointsGoal)))
  "Returns md5sum for a message object of type 'MoveJointsGoal"
  "657e3cbd4c41f25661ff55f41f7bf2cf")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<MoveJointsGoal>)))
  "Returns full string definition for message of type '<MoveJointsGoal>"
  (cl:format cl:nil "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======~%float64[] positions~%float64 time~%bool auto_generate_time~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'MoveJointsGoal)))
  "Returns full string definition for message of type 'MoveJointsGoal"
  (cl:format cl:nil "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======~%float64[] positions~%float64 time~%bool auto_generate_time~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <MoveJointsGoal>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'positions) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
     8
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <MoveJointsGoal>))
  "Converts a ROS message object to a list"
  (cl:list 'MoveJointsGoal
    (cl:cons ':positions (positions msg))
    (cl:cons ':time (time msg))
    (cl:cons ':auto_generate_time (auto_generate_time msg))
))

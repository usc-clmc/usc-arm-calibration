; Auto-generated. Do not edit!


(cl:in-package arm_msgs-msg)


;//! \htmlinclude Task.msg.html

(cl:defclass <Task> (roslisp-msg-protocol:ros-message)
  ((type
    :reader type
    :initarg :type
    :type cl:string
    :initform "")
   (object_name
    :reader object_name
    :initarg :object_name
    :type cl:string
    :initform "")
   (model_file_name
    :reader model_file_name
    :initarg :model_file_name
    :type cl:string
    :initform ""))
)

(cl:defclass Task (<Task>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Task>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Task)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_msgs-msg:<Task> is deprecated: use arm_msgs-msg:Task instead.")))

(cl:ensure-generic-function 'type-val :lambda-list '(m))
(cl:defmethod type-val ((m <Task>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-msg:type-val is deprecated.  Use arm_msgs-msg:type instead.")
  (type m))

(cl:ensure-generic-function 'object_name-val :lambda-list '(m))
(cl:defmethod object_name-val ((m <Task>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-msg:object_name-val is deprecated.  Use arm_msgs-msg:object_name instead.")
  (object_name m))

(cl:ensure-generic-function 'model_file_name-val :lambda-list '(m))
(cl:defmethod model_file_name-val ((m <Task>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-msg:model_file_name-val is deprecated.  Use arm_msgs-msg:model_file_name instead.")
  (model_file_name m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<Task>)))
    "Constants for message type '<Task>"
  '((:GRASP . grasp)
    (:STAPLE . staple)
    (:SWITCH_ON . turn_on)
    (:OPEN . open)
    (:UNLOCK . unlock)
    (:DRILL_HOLE . drill_hole)
    (:HANG_UP . hang_up))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'Task)))
    "Constants for message type 'Task"
  '((:GRASP . grasp)
    (:STAPLE . staple)
    (:SWITCH_ON . turn_on)
    (:OPEN . open)
    (:UNLOCK . unlock)
    (:DRILL_HOLE . drill_hole)
    (:HANG_UP . hang_up))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Task>) ostream)
  "Serializes a message object of type '<Task>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'type))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'type))
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'object_name))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'object_name))
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'model_file_name))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'model_file_name))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Task>) istream)
  "Deserializes a message object of type '<Task>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'type) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'type) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'object_name) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'object_name) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'model_file_name) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'model_file_name) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Task>)))
  "Returns string type for a message object of type '<Task>"
  "arm_msgs/Task")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Task)))
  "Returns string type for a message object of type 'Task"
  "arm_msgs/Task")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Task>)))
  "Returns md5sum for a message object of type '<Task>"
  "af0fe32f3bc95dcfb1565d4f6a906682")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Task)))
  "Returns md5sum for a message object of type 'Task"
  "af0fe32f3bc95dcfb1565d4f6a906682")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Task>)))
  "Returns full string definition for message of type '<Task>"
  (cl:format cl:nil "string type~%string GRASP=grasp~%string STAPLE=staple~%string SWITCH_ON=turn_on~%string OPEN=open~%string UNLOCK=unlock~%string DRILL_HOLE=drill_hole~%string HANG_UP=hang_up~%string object_name~%string model_file_name~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Task)))
  "Returns full string definition for message of type 'Task"
  (cl:format cl:nil "string type~%string GRASP=grasp~%string STAPLE=staple~%string SWITCH_ON=turn_on~%string OPEN=open~%string UNLOCK=unlock~%string DRILL_HOLE=drill_hole~%string HANG_UP=hang_up~%string object_name~%string model_file_name~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Task>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'type))
     4 (cl:length (cl:slot-value msg 'object_name))
     4 (cl:length (cl:slot-value msg 'model_file_name))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Task>))
  "Converts a ROS message object to a list"
  (cl:list 'Task
    (cl:cons ':type (type msg))
    (cl:cons ':object_name (object_name msg))
    (cl:cons ':model_file_name (model_file_name msg))
))

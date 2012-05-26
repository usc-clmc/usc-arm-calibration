; Auto-generated. Do not edit!


(cl:in-package arm_behavior_actions-msg)


;//! \htmlinclude LocateObjectsGoal.msg.html

(cl:defclass <LocateObjectsGoal> (roslisp-msg-protocol:ros-message)
  ((object_names
    :reader object_names
    :initarg :object_names
    :type (cl:vector cl:string)
   :initform (cl:make-array 0 :element-type 'cl:string :initial-element ""))
   (method
    :reader method
    :initarg :method
    :type cl:integer
    :initform 0))
)

(cl:defclass LocateObjectsGoal (<LocateObjectsGoal>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <LocateObjectsGoal>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'LocateObjectsGoal)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_behavior_actions-msg:<LocateObjectsGoal> is deprecated: use arm_behavior_actions-msg:LocateObjectsGoal instead.")))

(cl:ensure-generic-function 'object_names-val :lambda-list '(m))
(cl:defmethod object_names-val ((m <LocateObjectsGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_behavior_actions-msg:object_names-val is deprecated.  Use arm_behavior_actions-msg:object_names instead.")
  (object_names m))

(cl:ensure-generic-function 'method-val :lambda-list '(m))
(cl:defmethod method-val ((m <LocateObjectsGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_behavior_actions-msg:method-val is deprecated.  Use arm_behavior_actions-msg:method instead.")
  (method m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<LocateObjectsGoal>)))
    "Constants for message type '<LocateObjectsGoal>"
  '((:METHOD_DEFAULT . 0)
    (:METHOD_2D . 1)
    (:METHOD_3D . 2))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'LocateObjectsGoal)))
    "Constants for message type 'LocateObjectsGoal"
  '((:METHOD_DEFAULT . 0)
    (:METHOD_2D . 1)
    (:METHOD_3D . 2))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <LocateObjectsGoal>) ostream)
  "Serializes a message object of type '<LocateObjectsGoal>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'object_names))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((__ros_str_len (cl:length ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) ele))
   (cl:slot-value msg 'object_names))
  (cl:let* ((signed (cl:slot-value msg 'method)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <LocateObjectsGoal>) istream)
  "Deserializes a message object of type '<LocateObjectsGoal>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'object_names) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'object_names)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:aref vals i) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:aref vals i) __ros_str_idx) (cl:code-char (cl:read-byte istream))))))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'method) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<LocateObjectsGoal>)))
  "Returns string type for a message object of type '<LocateObjectsGoal>"
  "arm_behavior_actions/LocateObjectsGoal")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'LocateObjectsGoal)))
  "Returns string type for a message object of type 'LocateObjectsGoal"
  "arm_behavior_actions/LocateObjectsGoal")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<LocateObjectsGoal>)))
  "Returns md5sum for a message object of type '<LocateObjectsGoal>"
  "00e4758d6770db753ecf85903fff7535")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'LocateObjectsGoal)))
  "Returns md5sum for a message object of type 'LocateObjectsGoal"
  "00e4758d6770db753ecf85903fff7535")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<LocateObjectsGoal>)))
  "Returns full string definition for message of type '<LocateObjectsGoal>"
  (cl:format cl:nil "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======~%# Define the goal~%string[] object_names~%int32 method~%int32 METHOD_DEFAULT=0~%int32 METHOD_2D=1~%int32 METHOD_3D=2~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'LocateObjectsGoal)))
  "Returns full string definition for message of type 'LocateObjectsGoal"
  (cl:format cl:nil "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======~%# Define the goal~%string[] object_names~%int32 method~%int32 METHOD_DEFAULT=0~%int32 METHOD_2D=1~%int32 METHOD_3D=2~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <LocateObjectsGoal>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'object_names) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 4 (cl:length ele))))
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <LocateObjectsGoal>))
  "Converts a ROS message object to a list"
  (cl:list 'LocateObjectsGoal
    (cl:cons ':object_names (object_names msg))
    (cl:cons ':method (method msg))
))

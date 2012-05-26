; Auto-generated. Do not edit!


(cl:in-package arm_controller_msgs-msg)


;//! \htmlinclude ControllerStatus.msg.html

(cl:defclass <ControllerStatus> (roslisp-msg-protocol:ros-message)
  ((return_code
    :reader return_code
    :initarg :return_code
    :type cl:integer
    :initform 0)
   (status
    :reader status
    :initarg :status
    :type cl:string
    :initform "")
   (current_controller_stack
    :reader current_controller_stack
    :initarg :current_controller_stack
    :type cl:string
    :initform ""))
)

(cl:defclass ControllerStatus (<ControllerStatus>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <ControllerStatus>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'ControllerStatus)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-msg:<ControllerStatus> is deprecated: use arm_controller_msgs-msg:ControllerStatus instead.")))

(cl:ensure-generic-function 'return_code-val :lambda-list '(m))
(cl:defmethod return_code-val ((m <ControllerStatus>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:return_code-val is deprecated.  Use arm_controller_msgs-msg:return_code instead.")
  (return_code m))

(cl:ensure-generic-function 'status-val :lambda-list '(m))
(cl:defmethod status-val ((m <ControllerStatus>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:status-val is deprecated.  Use arm_controller_msgs-msg:status instead.")
  (status m))

(cl:ensure-generic-function 'current_controller_stack-val :lambda-list '(m))
(cl:defmethod current_controller_stack-val ((m <ControllerStatus>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:current_controller_stack-val is deprecated.  Use arm_controller_msgs-msg:current_controller_stack instead.")
  (current_controller_stack m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<ControllerStatus>)))
    "Constants for message type '<ControllerStatus>"
  '((:SUCCESS . 0)
    (:FAILURE . 1))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'ControllerStatus)))
    "Constants for message type 'ControllerStatus"
  '((:SUCCESS . 0)
    (:FAILURE . 1))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <ControllerStatus>) ostream)
  "Serializes a message object of type '<ControllerStatus>"
  (cl:let* ((signed (cl:slot-value msg 'return_code)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'status))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'status))
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'current_controller_stack))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'current_controller_stack))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <ControllerStatus>) istream)
  "Deserializes a message object of type '<ControllerStatus>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'return_code) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'status) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'status) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'current_controller_stack) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'current_controller_stack) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<ControllerStatus>)))
  "Returns string type for a message object of type '<ControllerStatus>"
  "arm_controller_msgs/ControllerStatus")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'ControllerStatus)))
  "Returns string type for a message object of type 'ControllerStatus"
  "arm_controller_msgs/ControllerStatus")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<ControllerStatus>)))
  "Returns md5sum for a message object of type '<ControllerStatus>"
  "fa63be2919acc865649cdb9449a63657")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'ControllerStatus)))
  "Returns md5sum for a message object of type 'ControllerStatus"
  "fa63be2919acc865649cdb9449a63657")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<ControllerStatus>)))
  "Returns full string definition for message of type '<ControllerStatus>"
  (cl:format cl:nil "int32 return_code~%int32 SUCCESS=0~%int32 FAILURE=1~%string status~%string current_controller_stack~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'ControllerStatus)))
  "Returns full string definition for message of type 'ControllerStatus"
  (cl:format cl:nil "int32 return_code~%int32 SUCCESS=0~%int32 FAILURE=1~%string status~%string current_controller_stack~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <ControllerStatus>))
  (cl:+ 0
     4
     4 (cl:length (cl:slot-value msg 'status))
     4 (cl:length (cl:slot-value msg 'current_controller_stack))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <ControllerStatus>))
  "Converts a ROS message object to a list"
  (cl:list 'ControllerStatus
    (cl:cons ':return_code (return_code msg))
    (cl:cons ':status (status msg))
    (cl:cons ':current_controller_stack (current_controller_stack msg))
))

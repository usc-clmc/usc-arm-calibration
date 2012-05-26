; Auto-generated. Do not edit!


(cl:in-package arm_msgs-msg)


;//! \htmlinclude StatusReport.msg.html

(cl:defclass <StatusReport> (roslisp-msg-protocol:ros-message)
  ((status
    :reader status
    :initarg :status
    :type cl:string
    :initform "")
   (mode
    :reader mode
    :initarg :mode
    :type cl:fixnum
    :initform 0))
)

(cl:defclass StatusReport (<StatusReport>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <StatusReport>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'StatusReport)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_msgs-msg:<StatusReport> is deprecated: use arm_msgs-msg:StatusReport instead.")))

(cl:ensure-generic-function 'status-val :lambda-list '(m))
(cl:defmethod status-val ((m <StatusReport>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-msg:status-val is deprecated.  Use arm_msgs-msg:status instead.")
  (status m))

(cl:ensure-generic-function 'mode-val :lambda-list '(m))
(cl:defmethod mode-val ((m <StatusReport>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-msg:mode-val is deprecated.  Use arm_msgs-msg:mode instead.")
  (mode m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<StatusReport>)))
    "Constants for message type '<StatusReport>"
  '((:DEBUG . 0)
    (:INFO . 1)
    (:WARN . 2)
    (:ERROR . 3)
    (:FATAL . 4))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'StatusReport)))
    "Constants for message type 'StatusReport"
  '((:DEBUG . 0)
    (:INFO . 1)
    (:WARN . 2)
    (:ERROR . 3)
    (:FATAL . 4))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <StatusReport>) ostream)
  "Serializes a message object of type '<StatusReport>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'status))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'status))
  (cl:let* ((signed (cl:slot-value msg 'mode)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <StatusReport>) istream)
  "Deserializes a message object of type '<StatusReport>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'status) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'status) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'mode) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<StatusReport>)))
  "Returns string type for a message object of type '<StatusReport>"
  "arm_msgs/StatusReport")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'StatusReport)))
  "Returns string type for a message object of type 'StatusReport"
  "arm_msgs/StatusReport")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<StatusReport>)))
  "Returns md5sum for a message object of type '<StatusReport>"
  "fd2942673344a91e4bdac1ddc7fa57aa")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'StatusReport)))
  "Returns md5sum for a message object of type 'StatusReport"
  "fd2942673344a91e4bdac1ddc7fa57aa")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<StatusReport>)))
  "Returns full string definition for message of type '<StatusReport>"
  (cl:format cl:nil "string status~%int8 mode~%int8 DEBUG=0~%int8 INFO=1~%int8 WARN=2~%int8 ERROR=3~%int8 FATAL=4~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'StatusReport)))
  "Returns full string definition for message of type 'StatusReport"
  (cl:format cl:nil "string status~%int8 mode~%int8 DEBUG=0~%int8 INFO=1~%int8 WARN=2~%int8 ERROR=3~%int8 FATAL=4~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <StatusReport>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'status))
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <StatusReport>))
  "Converts a ROS message object to a list"
  (cl:list 'StatusReport
    (cl:cons ':status (status msg))
    (cl:cons ':mode (mode msg))
))

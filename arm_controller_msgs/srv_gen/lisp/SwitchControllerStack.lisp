; Auto-generated. Do not edit!


(cl:in-package arm_controller_msgs-srv)


;//! \htmlinclude SwitchControllerStack-request.msg.html

(cl:defclass <SwitchControllerStack-request> (roslisp-msg-protocol:ros-message)
  ((controller_stacks
    :reader controller_stacks
    :initarg :controller_stacks
    :type (cl:vector cl:string)
   :initform (cl:make-array 0 :element-type 'cl:string :initial-element ""))
   (transition_time
    :reader transition_time
    :initarg :transition_time
    :type cl:real
    :initform 0))
)

(cl:defclass SwitchControllerStack-request (<SwitchControllerStack-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SwitchControllerStack-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SwitchControllerStack-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-srv:<SwitchControllerStack-request> is deprecated: use arm_controller_msgs-srv:SwitchControllerStack-request instead.")))

(cl:ensure-generic-function 'controller_stacks-val :lambda-list '(m))
(cl:defmethod controller_stacks-val ((m <SwitchControllerStack-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-srv:controller_stacks-val is deprecated.  Use arm_controller_msgs-srv:controller_stacks instead.")
  (controller_stacks m))

(cl:ensure-generic-function 'transition_time-val :lambda-list '(m))
(cl:defmethod transition_time-val ((m <SwitchControllerStack-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-srv:transition_time-val is deprecated.  Use arm_controller_msgs-srv:transition_time instead.")
  (transition_time m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SwitchControllerStack-request>) ostream)
  "Serializes a message object of type '<SwitchControllerStack-request>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'controller_stacks))))
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
   (cl:slot-value msg 'controller_stacks))
  (cl:let ((__sec (cl:floor (cl:slot-value msg 'transition_time)))
        (__nsec (cl:round (cl:* 1e9 (cl:- (cl:slot-value msg 'transition_time) (cl:floor (cl:slot-value msg 'transition_time)))))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 0) __nsec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __nsec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __nsec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __nsec) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SwitchControllerStack-request>) istream)
  "Deserializes a message object of type '<SwitchControllerStack-request>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'controller_stacks) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'controller_stacks)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:aref vals i) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:aref vals i) __ros_str_idx) (cl:code-char (cl:read-byte istream))))))))
    (cl:let ((__sec 0) (__nsec 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 0) __nsec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __nsec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __nsec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __nsec) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'transition_time) (cl:+ (cl:coerce __sec 'cl:double-float) (cl:/ __nsec 1e9))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SwitchControllerStack-request>)))
  "Returns string type for a service object of type '<SwitchControllerStack-request>"
  "arm_controller_msgs/SwitchControllerStackRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SwitchControllerStack-request)))
  "Returns string type for a service object of type 'SwitchControllerStack-request"
  "arm_controller_msgs/SwitchControllerStackRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SwitchControllerStack-request>)))
  "Returns md5sum for a message object of type '<SwitchControllerStack-request>"
  "a985954ae5f3ee1d395dee1a8c28409b")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SwitchControllerStack-request)))
  "Returns md5sum for a message object of type 'SwitchControllerStack-request"
  "a985954ae5f3ee1d395dee1a8c28409b")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SwitchControllerStack-request>)))
  "Returns full string definition for message of type '<SwitchControllerStack-request>"
  (cl:format cl:nil "string[] controller_stacks~%duration transition_time~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SwitchControllerStack-request)))
  "Returns full string definition for message of type 'SwitchControllerStack-request"
  (cl:format cl:nil "string[] controller_stacks~%duration transition_time~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SwitchControllerStack-request>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'controller_stacks) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 4 (cl:length ele))))
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SwitchControllerStack-request>))
  "Converts a ROS message object to a list"
  (cl:list 'SwitchControllerStack-request
    (cl:cons ':controller_stacks (controller_stacks msg))
    (cl:cons ':transition_time (transition_time msg))
))
;//! \htmlinclude SwitchControllerStack-response.msg.html

(cl:defclass <SwitchControllerStack-response> (roslisp-msg-protocol:ros-message)
  ((result
    :reader result
    :initarg :result
    :type cl:fixnum
    :initform 0))
)

(cl:defclass SwitchControllerStack-response (<SwitchControllerStack-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SwitchControllerStack-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SwitchControllerStack-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-srv:<SwitchControllerStack-response> is deprecated: use arm_controller_msgs-srv:SwitchControllerStack-response instead.")))

(cl:ensure-generic-function 'result-val :lambda-list '(m))
(cl:defmethod result-val ((m <SwitchControllerStack-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-srv:result-val is deprecated.  Use arm_controller_msgs-srv:result instead.")
  (result m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<SwitchControllerStack-response>)))
    "Constants for message type '<SwitchControllerStack-response>"
  '((:FAILURE . 0)
    (:SUCCESS . 1))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'SwitchControllerStack-response)))
    "Constants for message type 'SwitchControllerStack-response"
  '((:FAILURE . 0)
    (:SUCCESS . 1))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SwitchControllerStack-response>) ostream)
  "Serializes a message object of type '<SwitchControllerStack-response>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'result)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SwitchControllerStack-response>) istream)
  "Deserializes a message object of type '<SwitchControllerStack-response>"
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'result)) (cl:read-byte istream))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SwitchControllerStack-response>)))
  "Returns string type for a service object of type '<SwitchControllerStack-response>"
  "arm_controller_msgs/SwitchControllerStackResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SwitchControllerStack-response)))
  "Returns string type for a service object of type 'SwitchControllerStack-response"
  "arm_controller_msgs/SwitchControllerStackResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SwitchControllerStack-response>)))
  "Returns md5sum for a message object of type '<SwitchControllerStack-response>"
  "a985954ae5f3ee1d395dee1a8c28409b")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SwitchControllerStack-response)))
  "Returns md5sum for a message object of type 'SwitchControllerStack-response"
  "a985954ae5f3ee1d395dee1a8c28409b")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SwitchControllerStack-response>)))
  "Returns full string definition for message of type '<SwitchControllerStack-response>"
  (cl:format cl:nil "uint8 FAILURE=0~%uint8 SUCCESS=1~%uint8 result~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SwitchControllerStack-response)))
  "Returns full string definition for message of type 'SwitchControllerStack-response"
  (cl:format cl:nil "uint8 FAILURE=0~%uint8 SUCCESS=1~%uint8 result~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SwitchControllerStack-response>))
  (cl:+ 0
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SwitchControllerStack-response>))
  "Converts a ROS message object to a list"
  (cl:list 'SwitchControllerStack-response
    (cl:cons ':result (result msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'SwitchControllerStack)))
  'SwitchControllerStack-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'SwitchControllerStack)))
  'SwitchControllerStack-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SwitchControllerStack)))
  "Returns string type for a service object of type '<SwitchControllerStack>"
  "arm_controller_msgs/SwitchControllerStack")
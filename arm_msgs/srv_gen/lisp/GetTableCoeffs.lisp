; Auto-generated. Do not edit!


(cl:in-package arm_msgs-srv)


;//! \htmlinclude GetTableCoeffs-request.msg.html

(cl:defclass <GetTableCoeffs-request> (roslisp-msg-protocol:ros-message)
  ()
)

(cl:defclass GetTableCoeffs-request (<GetTableCoeffs-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <GetTableCoeffs-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'GetTableCoeffs-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_msgs-srv:<GetTableCoeffs-request> is deprecated: use arm_msgs-srv:GetTableCoeffs-request instead.")))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <GetTableCoeffs-request>) ostream)
  "Serializes a message object of type '<GetTableCoeffs-request>"
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <GetTableCoeffs-request>) istream)
  "Deserializes a message object of type '<GetTableCoeffs-request>"
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<GetTableCoeffs-request>)))
  "Returns string type for a service object of type '<GetTableCoeffs-request>"
  "arm_msgs/GetTableCoeffsRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'GetTableCoeffs-request)))
  "Returns string type for a service object of type 'GetTableCoeffs-request"
  "arm_msgs/GetTableCoeffsRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<GetTableCoeffs-request>)))
  "Returns md5sum for a message object of type '<GetTableCoeffs-request>"
  "852ddcb53d360da100517ad6fa9d857e")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'GetTableCoeffs-request)))
  "Returns md5sum for a message object of type 'GetTableCoeffs-request"
  "852ddcb53d360da100517ad6fa9d857e")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<GetTableCoeffs-request>)))
  "Returns full string definition for message of type '<GetTableCoeffs-request>"
  (cl:format cl:nil "~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'GetTableCoeffs-request)))
  "Returns full string definition for message of type 'GetTableCoeffs-request"
  (cl:format cl:nil "~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <GetTableCoeffs-request>))
  (cl:+ 0
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <GetTableCoeffs-request>))
  "Converts a ROS message object to a list"
  (cl:list 'GetTableCoeffs-request
))
;//! \htmlinclude GetTableCoeffs-response.msg.html

(cl:defclass <GetTableCoeffs-response> (roslisp-msg-protocol:ros-message)
  ((found
    :reader found
    :initarg :found
    :type cl:boolean
    :initform cl:nil)
   (a
    :reader a
    :initarg :a
    :type cl:float
    :initform 0.0)
   (b
    :reader b
    :initarg :b
    :type cl:float
    :initform 0.0)
   (c
    :reader c
    :initarg :c
    :type cl:float
    :initform 0.0)
   (d
    :reader d
    :initarg :d
    :type cl:float
    :initform 0.0))
)

(cl:defclass GetTableCoeffs-response (<GetTableCoeffs-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <GetTableCoeffs-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'GetTableCoeffs-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_msgs-srv:<GetTableCoeffs-response> is deprecated: use arm_msgs-srv:GetTableCoeffs-response instead.")))

(cl:ensure-generic-function 'found-val :lambda-list '(m))
(cl:defmethod found-val ((m <GetTableCoeffs-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-srv:found-val is deprecated.  Use arm_msgs-srv:found instead.")
  (found m))

(cl:ensure-generic-function 'a-val :lambda-list '(m))
(cl:defmethod a-val ((m <GetTableCoeffs-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-srv:a-val is deprecated.  Use arm_msgs-srv:a instead.")
  (a m))

(cl:ensure-generic-function 'b-val :lambda-list '(m))
(cl:defmethod b-val ((m <GetTableCoeffs-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-srv:b-val is deprecated.  Use arm_msgs-srv:b instead.")
  (b m))

(cl:ensure-generic-function 'c-val :lambda-list '(m))
(cl:defmethod c-val ((m <GetTableCoeffs-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-srv:c-val is deprecated.  Use arm_msgs-srv:c instead.")
  (c m))

(cl:ensure-generic-function 'd-val :lambda-list '(m))
(cl:defmethod d-val ((m <GetTableCoeffs-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-srv:d-val is deprecated.  Use arm_msgs-srv:d instead.")
  (d m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <GetTableCoeffs-response>) ostream)
  "Serializes a message object of type '<GetTableCoeffs-response>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'found) 1 0)) ostream)
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'a))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'b))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'c))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'd))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <GetTableCoeffs-response>) istream)
  "Deserializes a message object of type '<GetTableCoeffs-response>"
    (cl:setf (cl:slot-value msg 'found) (cl:not (cl:zerop (cl:read-byte istream))))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'a) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'b) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'c) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'd) (roslisp-utils:decode-double-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<GetTableCoeffs-response>)))
  "Returns string type for a service object of type '<GetTableCoeffs-response>"
  "arm_msgs/GetTableCoeffsResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'GetTableCoeffs-response)))
  "Returns string type for a service object of type 'GetTableCoeffs-response"
  "arm_msgs/GetTableCoeffsResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<GetTableCoeffs-response>)))
  "Returns md5sum for a message object of type '<GetTableCoeffs-response>"
  "852ddcb53d360da100517ad6fa9d857e")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'GetTableCoeffs-response)))
  "Returns md5sum for a message object of type 'GetTableCoeffs-response"
  "852ddcb53d360da100517ad6fa9d857e")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<GetTableCoeffs-response>)))
  "Returns full string definition for message of type '<GetTableCoeffs-response>"
  (cl:format cl:nil "bool found~%float64 a~%float64 b~%float64 c~%float64 d~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'GetTableCoeffs-response)))
  "Returns full string definition for message of type 'GetTableCoeffs-response"
  (cl:format cl:nil "bool found~%float64 a~%float64 b~%float64 c~%float64 d~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <GetTableCoeffs-response>))
  (cl:+ 0
     1
     8
     8
     8
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <GetTableCoeffs-response>))
  "Converts a ROS message object to a list"
  (cl:list 'GetTableCoeffs-response
    (cl:cons ':found (found msg))
    (cl:cons ':a (a msg))
    (cl:cons ':b (b msg))
    (cl:cons ':c (c msg))
    (cl:cons ':d (d msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'GetTableCoeffs)))
  'GetTableCoeffs-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'GetTableCoeffs)))
  'GetTableCoeffs-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'GetTableCoeffs)))
  "Returns string type for a service object of type '<GetTableCoeffs>"
  "arm_msgs/GetTableCoeffs")
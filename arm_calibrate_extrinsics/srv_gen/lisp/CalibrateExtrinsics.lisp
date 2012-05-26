; Auto-generated. Do not edit!


(cl:in-package arm_calibrate_extrinsics-srv)


;//! \htmlinclude CalibrateExtrinsics-request.msg.html

(cl:defclass <CalibrateExtrinsics-request> (roslisp-msg-protocol:ros-message)
  ()
)

(cl:defclass CalibrateExtrinsics-request (<CalibrateExtrinsics-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <CalibrateExtrinsics-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'CalibrateExtrinsics-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_calibrate_extrinsics-srv:<CalibrateExtrinsics-request> is deprecated: use arm_calibrate_extrinsics-srv:CalibrateExtrinsics-request instead.")))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <CalibrateExtrinsics-request>) ostream)
  "Serializes a message object of type '<CalibrateExtrinsics-request>"
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <CalibrateExtrinsics-request>) istream)
  "Deserializes a message object of type '<CalibrateExtrinsics-request>"
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<CalibrateExtrinsics-request>)))
  "Returns string type for a service object of type '<CalibrateExtrinsics-request>"
  "arm_calibrate_extrinsics/CalibrateExtrinsicsRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'CalibrateExtrinsics-request)))
  "Returns string type for a service object of type 'CalibrateExtrinsics-request"
  "arm_calibrate_extrinsics/CalibrateExtrinsicsRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<CalibrateExtrinsics-request>)))
  "Returns md5sum for a message object of type '<CalibrateExtrinsics-request>"
  "b07fa3ecc4713f4025214b4258afb809")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'CalibrateExtrinsics-request)))
  "Returns md5sum for a message object of type 'CalibrateExtrinsics-request"
  "b07fa3ecc4713f4025214b4258afb809")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<CalibrateExtrinsics-request>)))
  "Returns full string definition for message of type '<CalibrateExtrinsics-request>"
  (cl:format cl:nil "~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'CalibrateExtrinsics-request)))
  "Returns full string definition for message of type 'CalibrateExtrinsics-request"
  (cl:format cl:nil "~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <CalibrateExtrinsics-request>))
  (cl:+ 0
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <CalibrateExtrinsics-request>))
  "Converts a ROS message object to a list"
  (cl:list 'CalibrateExtrinsics-request
))
;//! \htmlinclude CalibrateExtrinsics-response.msg.html

(cl:defclass <CalibrateExtrinsics-response> (roslisp-msg-protocol:ros-message)
  ((result
    :reader result
    :initarg :result
    :type cl:integer
    :initform 0))
)

(cl:defclass CalibrateExtrinsics-response (<CalibrateExtrinsics-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <CalibrateExtrinsics-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'CalibrateExtrinsics-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_calibrate_extrinsics-srv:<CalibrateExtrinsics-response> is deprecated: use arm_calibrate_extrinsics-srv:CalibrateExtrinsics-response instead.")))

(cl:ensure-generic-function 'result-val :lambda-list '(m))
(cl:defmethod result-val ((m <CalibrateExtrinsics-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_calibrate_extrinsics-srv:result-val is deprecated.  Use arm_calibrate_extrinsics-srv:result instead.")
  (result m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<CalibrateExtrinsics-response>)))
    "Constants for message type '<CalibrateExtrinsics-response>"
  '((:FAILED . 0)
    (:SUCCEEDED . 1))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'CalibrateExtrinsics-response)))
    "Constants for message type 'CalibrateExtrinsics-response"
  '((:FAILED . 0)
    (:SUCCEEDED . 1))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <CalibrateExtrinsics-response>) ostream)
  "Serializes a message object of type '<CalibrateExtrinsics-response>"
  (cl:let* ((signed (cl:slot-value msg 'result)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <CalibrateExtrinsics-response>) istream)
  "Deserializes a message object of type '<CalibrateExtrinsics-response>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'result) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<CalibrateExtrinsics-response>)))
  "Returns string type for a service object of type '<CalibrateExtrinsics-response>"
  "arm_calibrate_extrinsics/CalibrateExtrinsicsResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'CalibrateExtrinsics-response)))
  "Returns string type for a service object of type 'CalibrateExtrinsics-response"
  "arm_calibrate_extrinsics/CalibrateExtrinsicsResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<CalibrateExtrinsics-response>)))
  "Returns md5sum for a message object of type '<CalibrateExtrinsics-response>"
  "b07fa3ecc4713f4025214b4258afb809")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'CalibrateExtrinsics-response)))
  "Returns md5sum for a message object of type 'CalibrateExtrinsics-response"
  "b07fa3ecc4713f4025214b4258afb809")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<CalibrateExtrinsics-response>)))
  "Returns full string definition for message of type '<CalibrateExtrinsics-response>"
  (cl:format cl:nil "int32 result~%int32 FAILED=0~%int32 SUCCEEDED=1~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'CalibrateExtrinsics-response)))
  "Returns full string definition for message of type 'CalibrateExtrinsics-response"
  (cl:format cl:nil "int32 result~%int32 FAILED=0~%int32 SUCCEEDED=1~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <CalibrateExtrinsics-response>))
  (cl:+ 0
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <CalibrateExtrinsics-response>))
  "Converts a ROS message object to a list"
  (cl:list 'CalibrateExtrinsics-response
    (cl:cons ':result (result msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'CalibrateExtrinsics)))
  'CalibrateExtrinsics-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'CalibrateExtrinsics)))
  'CalibrateExtrinsics-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'CalibrateExtrinsics)))
  "Returns string type for a service object of type '<CalibrateExtrinsics>"
  "arm_calibrate_extrinsics/CalibrateExtrinsics")
; Auto-generated. Do not edit!


(cl:in-package arm_controller_msgs-srv)


;//! \htmlinclude QueryControllerStatus-request.msg.html

(cl:defclass <QueryControllerStatus-request> (roslisp-msg-protocol:ros-message)
  ()
)

(cl:defclass QueryControllerStatus-request (<QueryControllerStatus-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <QueryControllerStatus-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'QueryControllerStatus-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-srv:<QueryControllerStatus-request> is deprecated: use arm_controller_msgs-srv:QueryControllerStatus-request instead.")))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <QueryControllerStatus-request>) ostream)
  "Serializes a message object of type '<QueryControllerStatus-request>"
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <QueryControllerStatus-request>) istream)
  "Deserializes a message object of type '<QueryControllerStatus-request>"
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<QueryControllerStatus-request>)))
  "Returns string type for a service object of type '<QueryControllerStatus-request>"
  "arm_controller_msgs/QueryControllerStatusRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'QueryControllerStatus-request)))
  "Returns string type for a service object of type 'QueryControllerStatus-request"
  "arm_controller_msgs/QueryControllerStatusRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<QueryControllerStatus-request>)))
  "Returns md5sum for a message object of type '<QueryControllerStatus-request>"
  "a5100f18212dd0b493d04f04e4849186")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'QueryControllerStatus-request)))
  "Returns md5sum for a message object of type 'QueryControllerStatus-request"
  "a5100f18212dd0b493d04f04e4849186")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<QueryControllerStatus-request>)))
  "Returns full string definition for message of type '<QueryControllerStatus-request>"
  (cl:format cl:nil "~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'QueryControllerStatus-request)))
  "Returns full string definition for message of type 'QueryControllerStatus-request"
  (cl:format cl:nil "~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <QueryControllerStatus-request>))
  (cl:+ 0
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <QueryControllerStatus-request>))
  "Converts a ROS message object to a list"
  (cl:list 'QueryControllerStatus-request
))
;//! \htmlinclude QueryControllerStatus-response.msg.html

(cl:defclass <QueryControllerStatus-response> (roslisp-msg-protocol:ros-message)
  ((status
    :reader status
    :initarg :status
    :type arm_controller_msgs-msg:ControllerStatus
    :initform (cl:make-instance 'arm_controller_msgs-msg:ControllerStatus)))
)

(cl:defclass QueryControllerStatus-response (<QueryControllerStatus-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <QueryControllerStatus-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'QueryControllerStatus-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-srv:<QueryControllerStatus-response> is deprecated: use arm_controller_msgs-srv:QueryControllerStatus-response instead.")))

(cl:ensure-generic-function 'status-val :lambda-list '(m))
(cl:defmethod status-val ((m <QueryControllerStatus-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-srv:status-val is deprecated.  Use arm_controller_msgs-srv:status instead.")
  (status m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <QueryControllerStatus-response>) ostream)
  "Serializes a message object of type '<QueryControllerStatus-response>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'status) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <QueryControllerStatus-response>) istream)
  "Deserializes a message object of type '<QueryControllerStatus-response>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'status) istream)
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<QueryControllerStatus-response>)))
  "Returns string type for a service object of type '<QueryControllerStatus-response>"
  "arm_controller_msgs/QueryControllerStatusResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'QueryControllerStatus-response)))
  "Returns string type for a service object of type 'QueryControllerStatus-response"
  "arm_controller_msgs/QueryControllerStatusResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<QueryControllerStatus-response>)))
  "Returns md5sum for a message object of type '<QueryControllerStatus-response>"
  "a5100f18212dd0b493d04f04e4849186")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'QueryControllerStatus-response)))
  "Returns md5sum for a message object of type 'QueryControllerStatus-response"
  "a5100f18212dd0b493d04f04e4849186")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<QueryControllerStatus-response>)))
  "Returns full string definition for message of type '<QueryControllerStatus-response>"
  (cl:format cl:nil "arm_controller_msgs/ControllerStatus status~%~%~%================================================================================~%MSG: arm_controller_msgs/ControllerStatus~%int32 return_code~%int32 SUCCESS=0~%int32 FAILURE=1~%string status~%string current_controller_stack~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'QueryControllerStatus-response)))
  "Returns full string definition for message of type 'QueryControllerStatus-response"
  (cl:format cl:nil "arm_controller_msgs/ControllerStatus status~%~%~%================================================================================~%MSG: arm_controller_msgs/ControllerStatus~%int32 return_code~%int32 SUCCESS=0~%int32 FAILURE=1~%string status~%string current_controller_stack~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <QueryControllerStatus-response>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'status))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <QueryControllerStatus-response>))
  "Converts a ROS message object to a list"
  (cl:list 'QueryControllerStatus-response
    (cl:cons ':status (status msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'QueryControllerStatus)))
  'QueryControllerStatus-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'QueryControllerStatus)))
  'QueryControllerStatus-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'QueryControllerStatus)))
  "Returns string type for a service object of type '<QueryControllerStatus>"
  "arm_controller_msgs/QueryControllerStatus")
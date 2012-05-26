; Auto-generated. Do not edit!


(cl:in-package arm_controller_msgs-msg)


;//! \htmlinclude CalibratePressureSensorsStatus.msg.html

(cl:defclass <CalibratePressureSensorsStatus> (roslisp-msg-protocol:ros-message)
  ()
)

(cl:defclass CalibratePressureSensorsStatus (<CalibratePressureSensorsStatus>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <CalibratePressureSensorsStatus>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'CalibratePressureSensorsStatus)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-msg:<CalibratePressureSensorsStatus> is deprecated: use arm_controller_msgs-msg:CalibratePressureSensorsStatus instead.")))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <CalibratePressureSensorsStatus>) ostream)
  "Serializes a message object of type '<CalibratePressureSensorsStatus>"
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <CalibratePressureSensorsStatus>) istream)
  "Deserializes a message object of type '<CalibratePressureSensorsStatus>"
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<CalibratePressureSensorsStatus>)))
  "Returns string type for a message object of type '<CalibratePressureSensorsStatus>"
  "arm_controller_msgs/CalibratePressureSensorsStatus")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'CalibratePressureSensorsStatus)))
  "Returns string type for a message object of type 'CalibratePressureSensorsStatus"
  "arm_controller_msgs/CalibratePressureSensorsStatus")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<CalibratePressureSensorsStatus>)))
  "Returns md5sum for a message object of type '<CalibratePressureSensorsStatus>"
  "d41d8cd98f00b204e9800998ecf8427e")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'CalibratePressureSensorsStatus)))
  "Returns md5sum for a message object of type 'CalibratePressureSensorsStatus"
  "d41d8cd98f00b204e9800998ecf8427e")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<CalibratePressureSensorsStatus>)))
  "Returns full string definition for message of type '<CalibratePressureSensorsStatus>"
  (cl:format cl:nil "# empty message for now~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'CalibratePressureSensorsStatus)))
  "Returns full string definition for message of type 'CalibratePressureSensorsStatus"
  (cl:format cl:nil "# empty message for now~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <CalibratePressureSensorsStatus>))
  (cl:+ 0
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <CalibratePressureSensorsStatus>))
  "Converts a ROS message object to a list"
  (cl:list 'CalibratePressureSensorsStatus
))

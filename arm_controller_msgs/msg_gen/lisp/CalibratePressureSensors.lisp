; Auto-generated. Do not edit!


(cl:in-package arm_controller_msgs-msg)


;//! \htmlinclude CalibratePressureSensors.msg.html

(cl:defclass <CalibratePressureSensors> (roslisp-msg-protocol:ros-message)
  ()
)

(cl:defclass CalibratePressureSensors (<CalibratePressureSensors>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <CalibratePressureSensors>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'CalibratePressureSensors)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-msg:<CalibratePressureSensors> is deprecated: use arm_controller_msgs-msg:CalibratePressureSensors instead.")))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <CalibratePressureSensors>) ostream)
  "Serializes a message object of type '<CalibratePressureSensors>"
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <CalibratePressureSensors>) istream)
  "Deserializes a message object of type '<CalibratePressureSensors>"
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<CalibratePressureSensors>)))
  "Returns string type for a message object of type '<CalibratePressureSensors>"
  "arm_controller_msgs/CalibratePressureSensors")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'CalibratePressureSensors)))
  "Returns string type for a message object of type 'CalibratePressureSensors"
  "arm_controller_msgs/CalibratePressureSensors")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<CalibratePressureSensors>)))
  "Returns md5sum for a message object of type '<CalibratePressureSensors>"
  "d41d8cd98f00b204e9800998ecf8427e")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'CalibratePressureSensors)))
  "Returns md5sum for a message object of type 'CalibratePressureSensors"
  "d41d8cd98f00b204e9800998ecf8427e")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<CalibratePressureSensors>)))
  "Returns full string definition for message of type '<CalibratePressureSensors>"
  (cl:format cl:nil "# empty message for now~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'CalibratePressureSensors)))
  "Returns full string definition for message of type 'CalibratePressureSensors"
  (cl:format cl:nil "# empty message for now~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <CalibratePressureSensors>))
  (cl:+ 0
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <CalibratePressureSensors>))
  "Converts a ROS message object to a list"
  (cl:list 'CalibratePressureSensors
))

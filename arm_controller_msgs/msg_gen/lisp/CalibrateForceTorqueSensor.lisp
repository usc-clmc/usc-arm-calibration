; Auto-generated. Do not edit!


(cl:in-package arm_controller_msgs-msg)


;//! \htmlinclude CalibrateForceTorqueSensor.msg.html

(cl:defclass <CalibrateForceTorqueSensor> (roslisp-msg-protocol:ros-message)
  ()
)

(cl:defclass CalibrateForceTorqueSensor (<CalibrateForceTorqueSensor>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <CalibrateForceTorqueSensor>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'CalibrateForceTorqueSensor)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-msg:<CalibrateForceTorqueSensor> is deprecated: use arm_controller_msgs-msg:CalibrateForceTorqueSensor instead.")))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <CalibrateForceTorqueSensor>) ostream)
  "Serializes a message object of type '<CalibrateForceTorqueSensor>"
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <CalibrateForceTorqueSensor>) istream)
  "Deserializes a message object of type '<CalibrateForceTorqueSensor>"
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<CalibrateForceTorqueSensor>)))
  "Returns string type for a message object of type '<CalibrateForceTorqueSensor>"
  "arm_controller_msgs/CalibrateForceTorqueSensor")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'CalibrateForceTorqueSensor)))
  "Returns string type for a message object of type 'CalibrateForceTorqueSensor"
  "arm_controller_msgs/CalibrateForceTorqueSensor")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<CalibrateForceTorqueSensor>)))
  "Returns md5sum for a message object of type '<CalibrateForceTorqueSensor>"
  "d41d8cd98f00b204e9800998ecf8427e")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'CalibrateForceTorqueSensor)))
  "Returns md5sum for a message object of type 'CalibrateForceTorqueSensor"
  "d41d8cd98f00b204e9800998ecf8427e")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<CalibrateForceTorqueSensor>)))
  "Returns full string definition for message of type '<CalibrateForceTorqueSensor>"
  (cl:format cl:nil "# empty message for now~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'CalibrateForceTorqueSensor)))
  "Returns full string definition for message of type 'CalibrateForceTorqueSensor"
  (cl:format cl:nil "# empty message for now~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <CalibrateForceTorqueSensor>))
  (cl:+ 0
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <CalibrateForceTorqueSensor>))
  "Converts a ROS message object to a list"
  (cl:list 'CalibrateForceTorqueSensor
))

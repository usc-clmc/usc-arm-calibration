; Auto-generated. Do not edit!


(cl:in-package arm_controller_msgs-msg)


;//! \htmlinclude CalibrateForceTorqueSensorStatus.msg.html

(cl:defclass <CalibrateForceTorqueSensorStatus> (roslisp-msg-protocol:ros-message)
  ()
)

(cl:defclass CalibrateForceTorqueSensorStatus (<CalibrateForceTorqueSensorStatus>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <CalibrateForceTorqueSensorStatus>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'CalibrateForceTorqueSensorStatus)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-msg:<CalibrateForceTorqueSensorStatus> is deprecated: use arm_controller_msgs-msg:CalibrateForceTorqueSensorStatus instead.")))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <CalibrateForceTorqueSensorStatus>) ostream)
  "Serializes a message object of type '<CalibrateForceTorqueSensorStatus>"
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <CalibrateForceTorqueSensorStatus>) istream)
  "Deserializes a message object of type '<CalibrateForceTorqueSensorStatus>"
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<CalibrateForceTorqueSensorStatus>)))
  "Returns string type for a message object of type '<CalibrateForceTorqueSensorStatus>"
  "arm_controller_msgs/CalibrateForceTorqueSensorStatus")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'CalibrateForceTorqueSensorStatus)))
  "Returns string type for a message object of type 'CalibrateForceTorqueSensorStatus"
  "arm_controller_msgs/CalibrateForceTorqueSensorStatus")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<CalibrateForceTorqueSensorStatus>)))
  "Returns md5sum for a message object of type '<CalibrateForceTorqueSensorStatus>"
  "d41d8cd98f00b204e9800998ecf8427e")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'CalibrateForceTorqueSensorStatus)))
  "Returns md5sum for a message object of type 'CalibrateForceTorqueSensorStatus"
  "d41d8cd98f00b204e9800998ecf8427e")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<CalibrateForceTorqueSensorStatus>)))
  "Returns full string definition for message of type '<CalibrateForceTorqueSensorStatus>"
  (cl:format cl:nil "# empty message for now~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'CalibrateForceTorqueSensorStatus)))
  "Returns full string definition for message of type 'CalibrateForceTorqueSensorStatus"
  (cl:format cl:nil "# empty message for now~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <CalibrateForceTorqueSensorStatus>))
  (cl:+ 0
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <CalibrateForceTorqueSensorStatus>))
  "Converts a ROS message object to a list"
  (cl:list 'CalibrateForceTorqueSensorStatus
))

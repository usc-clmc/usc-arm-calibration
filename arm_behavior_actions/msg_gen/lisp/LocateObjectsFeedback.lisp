; Auto-generated. Do not edit!


(cl:in-package arm_behavior_actions-msg)


;//! \htmlinclude LocateObjectsFeedback.msg.html

(cl:defclass <LocateObjectsFeedback> (roslisp-msg-protocol:ros-message)
  ()
)

(cl:defclass LocateObjectsFeedback (<LocateObjectsFeedback>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <LocateObjectsFeedback>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'LocateObjectsFeedback)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_behavior_actions-msg:<LocateObjectsFeedback> is deprecated: use arm_behavior_actions-msg:LocateObjectsFeedback instead.")))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <LocateObjectsFeedback>) ostream)
  "Serializes a message object of type '<LocateObjectsFeedback>"
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <LocateObjectsFeedback>) istream)
  "Deserializes a message object of type '<LocateObjectsFeedback>"
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<LocateObjectsFeedback>)))
  "Returns string type for a message object of type '<LocateObjectsFeedback>"
  "arm_behavior_actions/LocateObjectsFeedback")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'LocateObjectsFeedback)))
  "Returns string type for a message object of type 'LocateObjectsFeedback"
  "arm_behavior_actions/LocateObjectsFeedback")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<LocateObjectsFeedback>)))
  "Returns md5sum for a message object of type '<LocateObjectsFeedback>"
  "d41d8cd98f00b204e9800998ecf8427e")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'LocateObjectsFeedback)))
  "Returns md5sum for a message object of type 'LocateObjectsFeedback"
  "d41d8cd98f00b204e9800998ecf8427e")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<LocateObjectsFeedback>)))
  "Returns full string definition for message of type '<LocateObjectsFeedback>"
  (cl:format cl:nil "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======~%# Define a feedback message~%~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'LocateObjectsFeedback)))
  "Returns full string definition for message of type 'LocateObjectsFeedback"
  (cl:format cl:nil "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======~%# Define a feedback message~%~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <LocateObjectsFeedback>))
  (cl:+ 0
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <LocateObjectsFeedback>))
  "Converts a ROS message object to a list"
  (cl:list 'LocateObjectsFeedback
))
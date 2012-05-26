; Auto-generated. Do not edit!


(cl:in-package arm_controller_msgs-msg)


;//! \htmlinclude IncreaseMaxFingerTorque.msg.html

(cl:defclass <IncreaseMaxFingerTorque> (roslisp-msg-protocol:ros-message)
  ((num_steps
    :reader num_steps
    :initarg :num_steps
    :type cl:integer
    :initform 0))
)

(cl:defclass IncreaseMaxFingerTorque (<IncreaseMaxFingerTorque>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <IncreaseMaxFingerTorque>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'IncreaseMaxFingerTorque)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-msg:<IncreaseMaxFingerTorque> is deprecated: use arm_controller_msgs-msg:IncreaseMaxFingerTorque instead.")))

(cl:ensure-generic-function 'num_steps-val :lambda-list '(m))
(cl:defmethod num_steps-val ((m <IncreaseMaxFingerTorque>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:num_steps-val is deprecated.  Use arm_controller_msgs-msg:num_steps instead.")
  (num_steps m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <IncreaseMaxFingerTorque>) ostream)
  "Serializes a message object of type '<IncreaseMaxFingerTorque>"
  (cl:let* ((signed (cl:slot-value msg 'num_steps)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <IncreaseMaxFingerTorque>) istream)
  "Deserializes a message object of type '<IncreaseMaxFingerTorque>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'num_steps) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<IncreaseMaxFingerTorque>)))
  "Returns string type for a message object of type '<IncreaseMaxFingerTorque>"
  "arm_controller_msgs/IncreaseMaxFingerTorque")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'IncreaseMaxFingerTorque)))
  "Returns string type for a message object of type 'IncreaseMaxFingerTorque"
  "arm_controller_msgs/IncreaseMaxFingerTorque")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<IncreaseMaxFingerTorque>)))
  "Returns md5sum for a message object of type '<IncreaseMaxFingerTorque>"
  "ec92edc7544f0f2ee877e76a11710806")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'IncreaseMaxFingerTorque)))
  "Returns md5sum for a message object of type 'IncreaseMaxFingerTorque"
  "ec92edc7544f0f2ee877e76a11710806")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<IncreaseMaxFingerTorque>)))
  "Returns full string definition for message of type '<IncreaseMaxFingerTorque>"
  (cl:format cl:nil "##message requesting for a MT increase of the fingers~%int32 num_steps ##100 will have a duration 0f 300ms~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'IncreaseMaxFingerTorque)))
  "Returns full string definition for message of type 'IncreaseMaxFingerTorque"
  (cl:format cl:nil "##message requesting for a MT increase of the fingers~%int32 num_steps ##100 will have a duration 0f 300ms~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <IncreaseMaxFingerTorque>))
  (cl:+ 0
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <IncreaseMaxFingerTorque>))
  "Converts a ROS message object to a list"
  (cl:list 'IncreaseMaxFingerTorque
    (cl:cons ':num_steps (num_steps msg))
))

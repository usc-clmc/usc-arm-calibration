; Auto-generated. Do not edit!


(cl:in-package arm_msgs-msg)


;//! \htmlinclude Tasks.msg.html

(cl:defclass <Tasks> (roslisp-msg-protocol:ros-message)
  ((tasks
    :reader tasks
    :initarg :tasks
    :type (cl:vector arm_msgs-msg:Task)
   :initform (cl:make-array 0 :element-type 'arm_msgs-msg:Task :initial-element (cl:make-instance 'arm_msgs-msg:Task))))
)

(cl:defclass Tasks (<Tasks>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Tasks>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Tasks)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_msgs-msg:<Tasks> is deprecated: use arm_msgs-msg:Tasks instead.")))

(cl:ensure-generic-function 'tasks-val :lambda-list '(m))
(cl:defmethod tasks-val ((m <Tasks>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-msg:tasks-val is deprecated.  Use arm_msgs-msg:tasks instead.")
  (tasks m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Tasks>) ostream)
  "Serializes a message object of type '<Tasks>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'tasks))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'tasks))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Tasks>) istream)
  "Deserializes a message object of type '<Tasks>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'tasks) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'tasks)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'arm_msgs-msg:Task))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Tasks>)))
  "Returns string type for a message object of type '<Tasks>"
  "arm_msgs/Tasks")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Tasks)))
  "Returns string type for a message object of type 'Tasks"
  "arm_msgs/Tasks")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Tasks>)))
  "Returns md5sum for a message object of type '<Tasks>"
  "32b37a461a42726bf357da3d85ad3059")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Tasks)))
  "Returns md5sum for a message object of type 'Tasks"
  "32b37a461a42726bf357da3d85ad3059")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Tasks>)))
  "Returns full string definition for message of type '<Tasks>"
  (cl:format cl:nil "arm_msgs/Task[] tasks~%================================================================================~%MSG: arm_msgs/Task~%string type~%string GRASP=grasp~%string STAPLE=staple~%string SWITCH_ON=turn_on~%string OPEN=open~%string UNLOCK=unlock~%string DRILL_HOLE=drill_hole~%string HANG_UP=hang_up~%string object_name~%string model_file_name~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Tasks)))
  "Returns full string definition for message of type 'Tasks"
  (cl:format cl:nil "arm_msgs/Task[] tasks~%================================================================================~%MSG: arm_msgs/Task~%string type~%string GRASP=grasp~%string STAPLE=staple~%string SWITCH_ON=turn_on~%string OPEN=open~%string UNLOCK=unlock~%string DRILL_HOLE=drill_hole~%string HANG_UP=hang_up~%string object_name~%string model_file_name~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Tasks>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'tasks) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Tasks>))
  "Converts a ROS message object to a list"
  (cl:list 'Tasks
    (cl:cons ':tasks (tasks msg))
))

; Auto-generated. Do not edit!


(cl:in-package arm_behavior_actions-msg)


;//! \htmlinclude ManipulateObjectGoal.msg.html

(cl:defclass <ManipulateObjectGoal> (roslisp-msg-protocol:ros-message)
  ((objects
    :reader objects
    :initarg :objects
    :type (cl:vector arm_msgs-msg:Object)
   :initform (cl:make-array 0 :element-type 'arm_msgs-msg:Object :initial-element (cl:make-instance 'arm_msgs-msg:Object)))
   (task
    :reader task
    :initarg :task
    :type arm_msgs-msg:Task
    :initform (cl:make-instance 'arm_msgs-msg:Task))
   (retry_status
    :reader retry_status
    :initarg :retry_status
    :type cl:integer
    :initform 0))
)

(cl:defclass ManipulateObjectGoal (<ManipulateObjectGoal>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <ManipulateObjectGoal>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'ManipulateObjectGoal)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_behavior_actions-msg:<ManipulateObjectGoal> is deprecated: use arm_behavior_actions-msg:ManipulateObjectGoal instead.")))

(cl:ensure-generic-function 'objects-val :lambda-list '(m))
(cl:defmethod objects-val ((m <ManipulateObjectGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_behavior_actions-msg:objects-val is deprecated.  Use arm_behavior_actions-msg:objects instead.")
  (objects m))

(cl:ensure-generic-function 'task-val :lambda-list '(m))
(cl:defmethod task-val ((m <ManipulateObjectGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_behavior_actions-msg:task-val is deprecated.  Use arm_behavior_actions-msg:task instead.")
  (task m))

(cl:ensure-generic-function 'retry_status-val :lambda-list '(m))
(cl:defmethod retry_status-val ((m <ManipulateObjectGoal>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_behavior_actions-msg:retry_status-val is deprecated.  Use arm_behavior_actions-msg:retry_status instead.")
  (retry_status m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<ManipulateObjectGoal>)))
    "Constants for message type '<ManipulateObjectGoal>"
  '((:FIRST_TIME . 0))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'ManipulateObjectGoal)))
    "Constants for message type 'ManipulateObjectGoal"
  '((:FIRST_TIME . 0))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <ManipulateObjectGoal>) ostream)
  "Serializes a message object of type '<ManipulateObjectGoal>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'objects))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'objects))
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'task) ostream)
  (cl:let* ((signed (cl:slot-value msg 'retry_status)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <ManipulateObjectGoal>) istream)
  "Deserializes a message object of type '<ManipulateObjectGoal>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'objects) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'objects)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'arm_msgs-msg:Object))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'task) istream)
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'retry_status) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<ManipulateObjectGoal>)))
  "Returns string type for a message object of type '<ManipulateObjectGoal>"
  "arm_behavior_actions/ManipulateObjectGoal")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'ManipulateObjectGoal)))
  "Returns string type for a message object of type 'ManipulateObjectGoal"
  "arm_behavior_actions/ManipulateObjectGoal")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<ManipulateObjectGoal>)))
  "Returns md5sum for a message object of type '<ManipulateObjectGoal>"
  "5809621b79d2ef97f489d5ceea373c6b")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'ManipulateObjectGoal)))
  "Returns md5sum for a message object of type 'ManipulateObjectGoal"
  "5809621b79d2ef97f489d5ceea373c6b")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<ManipulateObjectGoal>)))
  "Returns full string definition for message of type '<ManipulateObjectGoal>"
  (cl:format cl:nil "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======~%# All objects needed for the task~%arm_msgs/Object[] objects~%~%# Task description~%arm_msgs/Task task~%~%# The retry status contains the number of times the behavior has failed before~%int32 retry_status~%int32 FIRST_TIME=0~%~%================================================================================~%MSG: arm_msgs/Object~%string name~%string ORANGE_PAPER=orange_paper~%string BALL=ball~%string ROCK=rock~%string CANTEEN=canteen~%string CANTEEN_STANDING=canteen_standing~%string CANTEEN_LYING=canteen_lying~%string PVC_PIPE_BIG=pipe~%string PVC_PIPE_BIG_STANDING=pipe_standing~%string PVC_PIPE_BIG_LYING=pipe_lying~%string STAPLER=stapler~%string FLASHLIGHT=flashlight~%string FLASHLIGHT_UP=flashlight_up~%string DOOR=door~%string DOOR_UNLOCK=door_unlock~%string BOTTLE=bottle~%string MAGLITE=maglite~%string MAGLITE_UP=maglite_up~%string MAGLITE_DOWN=maglite_down~%string MAGLITE_LYING=maglite_lying~%string RADIO=radio~%string HANDSET=handset~%string HANDSET_DOWN=handset_down~%string CRADLE=cradle~%string CRADLE_FLAT=cradle_flat~%string CRADLE_VERTICAL=cradle_vertical~%string SCREWDRIVER=screwdriver~%string DRILL=drill~%string DRILL_UPRIGHT=drill_upright~%string DRILL_BLOCK=drill_block~%string DRILL_BLOCK_LYING=drill_block_lying~%string DRILL_BLOCK_STANDING=drill_block_standing~%string RED_DOT=red_dot~%string SHOVEL=shovel~%string SHOVEL_FLAT=shovel_flat~%string SHOVEL_ONEDGE=shovel_onedge~%string HAMMER=hammer~%string HAMMER_DOWN=hammer_down~%string HAMMER_LYING=hammer_lying~%string HAMMER_UP=hammer_up~%string HAMMER_ONEDGE=hammer_onedge~%string FLOODLIGHT=floodlight~%string FLOODLIGHT_SIDE=floodlight_side~%string FLOODLIGHT_DOWN=floodlight_down~%string PELICAN=pelican~%string PELICAN_HANDLE_UP=pelican_handle_up~%string PELICAN_LABEL_UP=pelican_label_up~%string PELICAN_LABEL_DOWN=pelican_label_down~%string PELICAN_LEFT_EDGE_DOWN=pelican_left_edge_down~%string PELICAN_RIGHT_EDGE_DOWN=pelican_right_edge_down~%geometry_msgs/PoseWithCovarianceStamped pose~%~%================================================================================~%MSG: geometry_msgs/PoseWithCovarianceStamped~%# This expresses an estimated pose with a reference coordinate frame and timestamp~%~%Header header~%PoseWithCovariance pose~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/PoseWithCovariance~%# This represents a pose in free space with uncertainty.~%~%Pose pose~%~%# Row-major representation of the 6x6 covariance matrix~%# The orientation parameters use a fixed-axis representation.~%# In order, the parameters are:~%# (x, y, z, rotation about X axis, rotation about Y axis, rotation about Z axis)~%float64[36] covariance~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of postion and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%================================================================================~%MSG: arm_msgs/Task~%string type~%string GRASP=grasp~%string STAPLE=staple~%string SWITCH_ON=turn_on~%string OPEN=open~%string UNLOCK=unlock~%string DRILL_HOLE=drill_hole~%string HANG_UP=hang_up~%string object_name~%string model_file_name~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'ManipulateObjectGoal)))
  "Returns full string definition for message of type 'ManipulateObjectGoal"
  (cl:format cl:nil "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======~%# All objects needed for the task~%arm_msgs/Object[] objects~%~%# Task description~%arm_msgs/Task task~%~%# The retry status contains the number of times the behavior has failed before~%int32 retry_status~%int32 FIRST_TIME=0~%~%================================================================================~%MSG: arm_msgs/Object~%string name~%string ORANGE_PAPER=orange_paper~%string BALL=ball~%string ROCK=rock~%string CANTEEN=canteen~%string CANTEEN_STANDING=canteen_standing~%string CANTEEN_LYING=canteen_lying~%string PVC_PIPE_BIG=pipe~%string PVC_PIPE_BIG_STANDING=pipe_standing~%string PVC_PIPE_BIG_LYING=pipe_lying~%string STAPLER=stapler~%string FLASHLIGHT=flashlight~%string FLASHLIGHT_UP=flashlight_up~%string DOOR=door~%string DOOR_UNLOCK=door_unlock~%string BOTTLE=bottle~%string MAGLITE=maglite~%string MAGLITE_UP=maglite_up~%string MAGLITE_DOWN=maglite_down~%string MAGLITE_LYING=maglite_lying~%string RADIO=radio~%string HANDSET=handset~%string HANDSET_DOWN=handset_down~%string CRADLE=cradle~%string CRADLE_FLAT=cradle_flat~%string CRADLE_VERTICAL=cradle_vertical~%string SCREWDRIVER=screwdriver~%string DRILL=drill~%string DRILL_UPRIGHT=drill_upright~%string DRILL_BLOCK=drill_block~%string DRILL_BLOCK_LYING=drill_block_lying~%string DRILL_BLOCK_STANDING=drill_block_standing~%string RED_DOT=red_dot~%string SHOVEL=shovel~%string SHOVEL_FLAT=shovel_flat~%string SHOVEL_ONEDGE=shovel_onedge~%string HAMMER=hammer~%string HAMMER_DOWN=hammer_down~%string HAMMER_LYING=hammer_lying~%string HAMMER_UP=hammer_up~%string HAMMER_ONEDGE=hammer_onedge~%string FLOODLIGHT=floodlight~%string FLOODLIGHT_SIDE=floodlight_side~%string FLOODLIGHT_DOWN=floodlight_down~%string PELICAN=pelican~%string PELICAN_HANDLE_UP=pelican_handle_up~%string PELICAN_LABEL_UP=pelican_label_up~%string PELICAN_LABEL_DOWN=pelican_label_down~%string PELICAN_LEFT_EDGE_DOWN=pelican_left_edge_down~%string PELICAN_RIGHT_EDGE_DOWN=pelican_right_edge_down~%geometry_msgs/PoseWithCovarianceStamped pose~%~%================================================================================~%MSG: geometry_msgs/PoseWithCovarianceStamped~%# This expresses an estimated pose with a reference coordinate frame and timestamp~%~%Header header~%PoseWithCovariance pose~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/PoseWithCovariance~%# This represents a pose in free space with uncertainty.~%~%Pose pose~%~%# Row-major representation of the 6x6 covariance matrix~%# The orientation parameters use a fixed-axis representation.~%# In order, the parameters are:~%# (x, y, z, rotation about X axis, rotation about Y axis, rotation about Z axis)~%float64[36] covariance~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of postion and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%================================================================================~%MSG: arm_msgs/Task~%string type~%string GRASP=grasp~%string STAPLE=staple~%string SWITCH_ON=turn_on~%string OPEN=open~%string UNLOCK=unlock~%string DRILL_HOLE=drill_hole~%string HANG_UP=hang_up~%string object_name~%string model_file_name~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <ManipulateObjectGoal>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'objects) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'task))
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <ManipulateObjectGoal>))
  "Converts a ROS message object to a list"
  (cl:list 'ManipulateObjectGoal
    (cl:cons ':objects (objects msg))
    (cl:cons ':task (task msg))
    (cl:cons ':retry_status (retry_status msg))
))

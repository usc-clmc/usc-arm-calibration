; Auto-generated. Do not edit!


(cl:in-package arm_msgs-srv)


;//! \htmlinclude FindObjectMulti-request.msg.html

(cl:defclass <FindObjectMulti-request> (roslisp-msg-protocol:ros-message)
  ((names
    :reader names
    :initarg :names
    :type (cl:vector cl:string)
   :initform (cl:make-array 0 :element-type 'cl:string :initial-element "")))
)

(cl:defclass FindObjectMulti-request (<FindObjectMulti-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <FindObjectMulti-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'FindObjectMulti-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_msgs-srv:<FindObjectMulti-request> is deprecated: use arm_msgs-srv:FindObjectMulti-request instead.")))

(cl:ensure-generic-function 'names-val :lambda-list '(m))
(cl:defmethod names-val ((m <FindObjectMulti-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-srv:names-val is deprecated.  Use arm_msgs-srv:names instead.")
  (names m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <FindObjectMulti-request>) ostream)
  "Serializes a message object of type '<FindObjectMulti-request>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'names))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((__ros_str_len (cl:length ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) ele))
   (cl:slot-value msg 'names))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <FindObjectMulti-request>) istream)
  "Deserializes a message object of type '<FindObjectMulti-request>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'names) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'names)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:aref vals i) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:aref vals i) __ros_str_idx) (cl:code-char (cl:read-byte istream))))))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<FindObjectMulti-request>)))
  "Returns string type for a service object of type '<FindObjectMulti-request>"
  "arm_msgs/FindObjectMultiRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'FindObjectMulti-request)))
  "Returns string type for a service object of type 'FindObjectMulti-request"
  "arm_msgs/FindObjectMultiRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<FindObjectMulti-request>)))
  "Returns md5sum for a message object of type '<FindObjectMulti-request>"
  "a11360d14f6db317e12a50f0a06c4121")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'FindObjectMulti-request)))
  "Returns md5sum for a message object of type 'FindObjectMulti-request"
  "a11360d14f6db317e12a50f0a06c4121")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<FindObjectMulti-request>)))
  "Returns full string definition for message of type '<FindObjectMulti-request>"
  (cl:format cl:nil "string[] names~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'FindObjectMulti-request)))
  "Returns full string definition for message of type 'FindObjectMulti-request"
  (cl:format cl:nil "string[] names~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <FindObjectMulti-request>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'names) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 4 (cl:length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <FindObjectMulti-request>))
  "Converts a ROS message object to a list"
  (cl:list 'FindObjectMulti-request
    (cl:cons ':names (names msg))
))
;//! \htmlinclude FindObjectMulti-response.msg.html

(cl:defclass <FindObjectMulti-response> (roslisp-msg-protocol:ros-message)
  ((objects
    :reader objects
    :initarg :objects
    :type (cl:vector arm_msgs-msg:Object)
   :initform (cl:make-array 0 :element-type 'arm_msgs-msg:Object :initial-element (cl:make-instance 'arm_msgs-msg:Object))))
)

(cl:defclass FindObjectMulti-response (<FindObjectMulti-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <FindObjectMulti-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'FindObjectMulti-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_msgs-srv:<FindObjectMulti-response> is deprecated: use arm_msgs-srv:FindObjectMulti-response instead.")))

(cl:ensure-generic-function 'objects-val :lambda-list '(m))
(cl:defmethod objects-val ((m <FindObjectMulti-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-srv:objects-val is deprecated.  Use arm_msgs-srv:objects instead.")
  (objects m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <FindObjectMulti-response>) ostream)
  "Serializes a message object of type '<FindObjectMulti-response>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'objects))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'objects))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <FindObjectMulti-response>) istream)
  "Deserializes a message object of type '<FindObjectMulti-response>"
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
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<FindObjectMulti-response>)))
  "Returns string type for a service object of type '<FindObjectMulti-response>"
  "arm_msgs/FindObjectMultiResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'FindObjectMulti-response)))
  "Returns string type for a service object of type 'FindObjectMulti-response"
  "arm_msgs/FindObjectMultiResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<FindObjectMulti-response>)))
  "Returns md5sum for a message object of type '<FindObjectMulti-response>"
  "a11360d14f6db317e12a50f0a06c4121")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'FindObjectMulti-response)))
  "Returns md5sum for a message object of type 'FindObjectMulti-response"
  "a11360d14f6db317e12a50f0a06c4121")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<FindObjectMulti-response>)))
  "Returns full string definition for message of type '<FindObjectMulti-response>"
  (cl:format cl:nil "arm_msgs/Object[] objects~%~%~%================================================================================~%MSG: arm_msgs/Object~%string name~%string ORANGE_PAPER=orange_paper~%string BALL=ball~%string ROCK=rock~%string CANTEEN=canteen~%string CANTEEN_STANDING=canteen_standing~%string CANTEEN_LYING=canteen_lying~%string PVC_PIPE_BIG=pipe~%string PVC_PIPE_BIG_STANDING=pipe_standing~%string PVC_PIPE_BIG_LYING=pipe_lying~%string STAPLER=stapler~%string FLASHLIGHT=flashlight~%string FLASHLIGHT_UP=flashlight_up~%string DOOR=door~%string DOOR_UNLOCK=door_unlock~%string BOTTLE=bottle~%string MAGLITE=maglite~%string MAGLITE_UP=maglite_up~%string MAGLITE_DOWN=maglite_down~%string MAGLITE_LYING=maglite_lying~%string RADIO=radio~%string HANDSET=handset~%string HANDSET_DOWN=handset_down~%string CRADLE=cradle~%string CRADLE_FLAT=cradle_flat~%string CRADLE_VERTICAL=cradle_vertical~%string SCREWDRIVER=screwdriver~%string DRILL=drill~%string DRILL_UPRIGHT=drill_upright~%string DRILL_BLOCK=drill_block~%string DRILL_BLOCK_LYING=drill_block_lying~%string DRILL_BLOCK_STANDING=drill_block_standing~%string RED_DOT=red_dot~%string SHOVEL=shovel~%string SHOVEL_FLAT=shovel_flat~%string SHOVEL_ONEDGE=shovel_onedge~%string HAMMER=hammer~%string HAMMER_DOWN=hammer_down~%string HAMMER_LYING=hammer_lying~%string HAMMER_UP=hammer_up~%string HAMMER_ONEDGE=hammer_onedge~%string FLOODLIGHT=floodlight~%string FLOODLIGHT_SIDE=floodlight_side~%string FLOODLIGHT_DOWN=floodlight_down~%string PELICAN=pelican~%string PELICAN_HANDLE_UP=pelican_handle_up~%string PELICAN_LABEL_UP=pelican_label_up~%string PELICAN_LABEL_DOWN=pelican_label_down~%string PELICAN_LEFT_EDGE_DOWN=pelican_left_edge_down~%string PELICAN_RIGHT_EDGE_DOWN=pelican_right_edge_down~%geometry_msgs/PoseWithCovarianceStamped pose~%~%================================================================================~%MSG: geometry_msgs/PoseWithCovarianceStamped~%# This expresses an estimated pose with a reference coordinate frame and timestamp~%~%Header header~%PoseWithCovariance pose~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/PoseWithCovariance~%# This represents a pose in free space with uncertainty.~%~%Pose pose~%~%# Row-major representation of the 6x6 covariance matrix~%# The orientation parameters use a fixed-axis representation.~%# In order, the parameters are:~%# (x, y, z, rotation about X axis, rotation about Y axis, rotation about Z axis)~%float64[36] covariance~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of postion and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'FindObjectMulti-response)))
  "Returns full string definition for message of type 'FindObjectMulti-response"
  (cl:format cl:nil "arm_msgs/Object[] objects~%~%~%================================================================================~%MSG: arm_msgs/Object~%string name~%string ORANGE_PAPER=orange_paper~%string BALL=ball~%string ROCK=rock~%string CANTEEN=canteen~%string CANTEEN_STANDING=canteen_standing~%string CANTEEN_LYING=canteen_lying~%string PVC_PIPE_BIG=pipe~%string PVC_PIPE_BIG_STANDING=pipe_standing~%string PVC_PIPE_BIG_LYING=pipe_lying~%string STAPLER=stapler~%string FLASHLIGHT=flashlight~%string FLASHLIGHT_UP=flashlight_up~%string DOOR=door~%string DOOR_UNLOCK=door_unlock~%string BOTTLE=bottle~%string MAGLITE=maglite~%string MAGLITE_UP=maglite_up~%string MAGLITE_DOWN=maglite_down~%string MAGLITE_LYING=maglite_lying~%string RADIO=radio~%string HANDSET=handset~%string HANDSET_DOWN=handset_down~%string CRADLE=cradle~%string CRADLE_FLAT=cradle_flat~%string CRADLE_VERTICAL=cradle_vertical~%string SCREWDRIVER=screwdriver~%string DRILL=drill~%string DRILL_UPRIGHT=drill_upright~%string DRILL_BLOCK=drill_block~%string DRILL_BLOCK_LYING=drill_block_lying~%string DRILL_BLOCK_STANDING=drill_block_standing~%string RED_DOT=red_dot~%string SHOVEL=shovel~%string SHOVEL_FLAT=shovel_flat~%string SHOVEL_ONEDGE=shovel_onedge~%string HAMMER=hammer~%string HAMMER_DOWN=hammer_down~%string HAMMER_LYING=hammer_lying~%string HAMMER_UP=hammer_up~%string HAMMER_ONEDGE=hammer_onedge~%string FLOODLIGHT=floodlight~%string FLOODLIGHT_SIDE=floodlight_side~%string FLOODLIGHT_DOWN=floodlight_down~%string PELICAN=pelican~%string PELICAN_HANDLE_UP=pelican_handle_up~%string PELICAN_LABEL_UP=pelican_label_up~%string PELICAN_LABEL_DOWN=pelican_label_down~%string PELICAN_LEFT_EDGE_DOWN=pelican_left_edge_down~%string PELICAN_RIGHT_EDGE_DOWN=pelican_right_edge_down~%geometry_msgs/PoseWithCovarianceStamped pose~%~%================================================================================~%MSG: geometry_msgs/PoseWithCovarianceStamped~%# This expresses an estimated pose with a reference coordinate frame and timestamp~%~%Header header~%PoseWithCovariance pose~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/PoseWithCovariance~%# This represents a pose in free space with uncertainty.~%~%Pose pose~%~%# Row-major representation of the 6x6 covariance matrix~%# The orientation parameters use a fixed-axis representation.~%# In order, the parameters are:~%# (x, y, z, rotation about X axis, rotation about Y axis, rotation about Z axis)~%float64[36] covariance~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of postion and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <FindObjectMulti-response>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'objects) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <FindObjectMulti-response>))
  "Converts a ROS message object to a list"
  (cl:list 'FindObjectMulti-response
    (cl:cons ':objects (objects msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'FindObjectMulti)))
  'FindObjectMulti-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'FindObjectMulti)))
  'FindObjectMulti-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'FindObjectMulti)))
  "Returns string type for a service object of type '<FindObjectMulti>"
  "arm_msgs/FindObjectMulti")
; Auto-generated. Do not edit!


(cl:in-package arm_msgs-srv)


;//! \htmlinclude FindObject-request.msg.html

(cl:defclass <FindObject-request> (roslisp-msg-protocol:ros-message)
  ((name
    :reader name
    :initarg :name
    :type cl:string
    :initform "")
   (has_parent_object
    :reader has_parent_object
    :initarg :has_parent_object
    :type cl:boolean
    :initform cl:nil)
   (parent_object
    :reader parent_object
    :initarg :parent_object
    :type arm_msgs-msg:Object
    :initform (cl:make-instance 'arm_msgs-msg:Object)))
)

(cl:defclass FindObject-request (<FindObject-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <FindObject-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'FindObject-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_msgs-srv:<FindObject-request> is deprecated: use arm_msgs-srv:FindObject-request instead.")))

(cl:ensure-generic-function 'name-val :lambda-list '(m))
(cl:defmethod name-val ((m <FindObject-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-srv:name-val is deprecated.  Use arm_msgs-srv:name instead.")
  (name m))

(cl:ensure-generic-function 'has_parent_object-val :lambda-list '(m))
(cl:defmethod has_parent_object-val ((m <FindObject-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-srv:has_parent_object-val is deprecated.  Use arm_msgs-srv:has_parent_object instead.")
  (has_parent_object m))

(cl:ensure-generic-function 'parent_object-val :lambda-list '(m))
(cl:defmethod parent_object-val ((m <FindObject-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-srv:parent_object-val is deprecated.  Use arm_msgs-srv:parent_object instead.")
  (parent_object m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <FindObject-request>) ostream)
  "Serializes a message object of type '<FindObject-request>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'name))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'name))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'has_parent_object) 1 0)) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'parent_object) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <FindObject-request>) istream)
  "Deserializes a message object of type '<FindObject-request>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'name) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'name) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:setf (cl:slot-value msg 'has_parent_object) (cl:not (cl:zerop (cl:read-byte istream))))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'parent_object) istream)
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<FindObject-request>)))
  "Returns string type for a service object of type '<FindObject-request>"
  "arm_msgs/FindObjectRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'FindObject-request)))
  "Returns string type for a service object of type 'FindObject-request"
  "arm_msgs/FindObjectRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<FindObject-request>)))
  "Returns md5sum for a message object of type '<FindObject-request>"
  "0e43fcf0548937f45b7976a4586a628c")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'FindObject-request)))
  "Returns md5sum for a message object of type 'FindObject-request"
  "0e43fcf0548937f45b7976a4586a628c")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<FindObject-request>)))
  "Returns full string definition for message of type '<FindObject-request>"
  (cl:format cl:nil "~%string name~%~%~%~%bool has_parent_object~%arm_msgs/Object parent_object~%~%================================================================================~%MSG: arm_msgs/Object~%string name~%string ORANGE_PAPER=orange_paper~%string BALL=ball~%string ROCK=rock~%string CANTEEN=canteen~%string CANTEEN_STANDING=canteen_standing~%string CANTEEN_LYING=canteen_lying~%string PVC_PIPE_BIG=pipe~%string PVC_PIPE_BIG_STANDING=pipe_standing~%string PVC_PIPE_BIG_LYING=pipe_lying~%string STAPLER=stapler~%string FLASHLIGHT=flashlight~%string FLASHLIGHT_UP=flashlight_up~%string DOOR=door~%string DOOR_UNLOCK=door_unlock~%string BOTTLE=bottle~%string MAGLITE=maglite~%string MAGLITE_UP=maglite_up~%string MAGLITE_DOWN=maglite_down~%string MAGLITE_LYING=maglite_lying~%string RADIO=radio~%string HANDSET=handset~%string HANDSET_DOWN=handset_down~%string CRADLE=cradle~%string CRADLE_FLAT=cradle_flat~%string CRADLE_VERTICAL=cradle_vertical~%string SCREWDRIVER=screwdriver~%string DRILL=drill~%string DRILL_UPRIGHT=drill_upright~%string DRILL_BLOCK=drill_block~%string DRILL_BLOCK_LYING=drill_block_lying~%string DRILL_BLOCK_STANDING=drill_block_standing~%string RED_DOT=red_dot~%string SHOVEL=shovel~%string SHOVEL_FLAT=shovel_flat~%string SHOVEL_ONEDGE=shovel_onedge~%string HAMMER=hammer~%string HAMMER_DOWN=hammer_down~%string HAMMER_LYING=hammer_lying~%string HAMMER_UP=hammer_up~%string HAMMER_ONEDGE=hammer_onedge~%string FLOODLIGHT=floodlight~%string FLOODLIGHT_SIDE=floodlight_side~%string FLOODLIGHT_DOWN=floodlight_down~%string PELICAN=pelican~%string PELICAN_HANDLE_UP=pelican_handle_up~%string PELICAN_LABEL_UP=pelican_label_up~%string PELICAN_LABEL_DOWN=pelican_label_down~%string PELICAN_LEFT_EDGE_DOWN=pelican_left_edge_down~%string PELICAN_RIGHT_EDGE_DOWN=pelican_right_edge_down~%geometry_msgs/PoseWithCovarianceStamped pose~%~%================================================================================~%MSG: geometry_msgs/PoseWithCovarianceStamped~%# This expresses an estimated pose with a reference coordinate frame and timestamp~%~%Header header~%PoseWithCovariance pose~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/PoseWithCovariance~%# This represents a pose in free space with uncertainty.~%~%Pose pose~%~%# Row-major representation of the 6x6 covariance matrix~%# The orientation parameters use a fixed-axis representation.~%# In order, the parameters are:~%# (x, y, z, rotation about X axis, rotation about Y axis, rotation about Z axis)~%float64[36] covariance~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of postion and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'FindObject-request)))
  "Returns full string definition for message of type 'FindObject-request"
  (cl:format cl:nil "~%string name~%~%~%~%bool has_parent_object~%arm_msgs/Object parent_object~%~%================================================================================~%MSG: arm_msgs/Object~%string name~%string ORANGE_PAPER=orange_paper~%string BALL=ball~%string ROCK=rock~%string CANTEEN=canteen~%string CANTEEN_STANDING=canteen_standing~%string CANTEEN_LYING=canteen_lying~%string PVC_PIPE_BIG=pipe~%string PVC_PIPE_BIG_STANDING=pipe_standing~%string PVC_PIPE_BIG_LYING=pipe_lying~%string STAPLER=stapler~%string FLASHLIGHT=flashlight~%string FLASHLIGHT_UP=flashlight_up~%string DOOR=door~%string DOOR_UNLOCK=door_unlock~%string BOTTLE=bottle~%string MAGLITE=maglite~%string MAGLITE_UP=maglite_up~%string MAGLITE_DOWN=maglite_down~%string MAGLITE_LYING=maglite_lying~%string RADIO=radio~%string HANDSET=handset~%string HANDSET_DOWN=handset_down~%string CRADLE=cradle~%string CRADLE_FLAT=cradle_flat~%string CRADLE_VERTICAL=cradle_vertical~%string SCREWDRIVER=screwdriver~%string DRILL=drill~%string DRILL_UPRIGHT=drill_upright~%string DRILL_BLOCK=drill_block~%string DRILL_BLOCK_LYING=drill_block_lying~%string DRILL_BLOCK_STANDING=drill_block_standing~%string RED_DOT=red_dot~%string SHOVEL=shovel~%string SHOVEL_FLAT=shovel_flat~%string SHOVEL_ONEDGE=shovel_onedge~%string HAMMER=hammer~%string HAMMER_DOWN=hammer_down~%string HAMMER_LYING=hammer_lying~%string HAMMER_UP=hammer_up~%string HAMMER_ONEDGE=hammer_onedge~%string FLOODLIGHT=floodlight~%string FLOODLIGHT_SIDE=floodlight_side~%string FLOODLIGHT_DOWN=floodlight_down~%string PELICAN=pelican~%string PELICAN_HANDLE_UP=pelican_handle_up~%string PELICAN_LABEL_UP=pelican_label_up~%string PELICAN_LABEL_DOWN=pelican_label_down~%string PELICAN_LEFT_EDGE_DOWN=pelican_left_edge_down~%string PELICAN_RIGHT_EDGE_DOWN=pelican_right_edge_down~%geometry_msgs/PoseWithCovarianceStamped pose~%~%================================================================================~%MSG: geometry_msgs/PoseWithCovarianceStamped~%# This expresses an estimated pose with a reference coordinate frame and timestamp~%~%Header header~%PoseWithCovariance pose~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/PoseWithCovariance~%# This represents a pose in free space with uncertainty.~%~%Pose pose~%~%# Row-major representation of the 6x6 covariance matrix~%# The orientation parameters use a fixed-axis representation.~%# In order, the parameters are:~%# (x, y, z, rotation about X axis, rotation about Y axis, rotation about Z axis)~%float64[36] covariance~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of postion and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <FindObject-request>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'name))
     1
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'parent_object))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <FindObject-request>))
  "Converts a ROS message object to a list"
  (cl:list 'FindObject-request
    (cl:cons ':name (name msg))
    (cl:cons ':has_parent_object (has_parent_object msg))
    (cl:cons ':parent_object (parent_object msg))
))
;//! \htmlinclude FindObject-response.msg.html

(cl:defclass <FindObject-response> (roslisp-msg-protocol:ros-message)
  ((found
    :reader found
    :initarg :found
    :type cl:boolean
    :initform cl:nil)
   (object
    :reader object
    :initarg :object
    :type arm_msgs-msg:Object
    :initform (cl:make-instance 'arm_msgs-msg:Object)))
)

(cl:defclass FindObject-response (<FindObject-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <FindObject-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'FindObject-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_msgs-srv:<FindObject-response> is deprecated: use arm_msgs-srv:FindObject-response instead.")))

(cl:ensure-generic-function 'found-val :lambda-list '(m))
(cl:defmethod found-val ((m <FindObject-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-srv:found-val is deprecated.  Use arm_msgs-srv:found instead.")
  (found m))

(cl:ensure-generic-function 'object-val :lambda-list '(m))
(cl:defmethod object-val ((m <FindObject-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-srv:object-val is deprecated.  Use arm_msgs-srv:object instead.")
  (object m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <FindObject-response>) ostream)
  "Serializes a message object of type '<FindObject-response>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'found) 1 0)) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'object) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <FindObject-response>) istream)
  "Deserializes a message object of type '<FindObject-response>"
    (cl:setf (cl:slot-value msg 'found) (cl:not (cl:zerop (cl:read-byte istream))))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'object) istream)
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<FindObject-response>)))
  "Returns string type for a service object of type '<FindObject-response>"
  "arm_msgs/FindObjectResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'FindObject-response)))
  "Returns string type for a service object of type 'FindObject-response"
  "arm_msgs/FindObjectResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<FindObject-response>)))
  "Returns md5sum for a message object of type '<FindObject-response>"
  "0e43fcf0548937f45b7976a4586a628c")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'FindObject-response)))
  "Returns md5sum for a message object of type 'FindObject-response"
  "0e43fcf0548937f45b7976a4586a628c")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<FindObject-response>)))
  "Returns full string definition for message of type '<FindObject-response>"
  (cl:format cl:nil "bool found~%arm_msgs/Object object~%~%~%================================================================================~%MSG: arm_msgs/Object~%string name~%string ORANGE_PAPER=orange_paper~%string BALL=ball~%string ROCK=rock~%string CANTEEN=canteen~%string CANTEEN_STANDING=canteen_standing~%string CANTEEN_LYING=canteen_lying~%string PVC_PIPE_BIG=pipe~%string PVC_PIPE_BIG_STANDING=pipe_standing~%string PVC_PIPE_BIG_LYING=pipe_lying~%string STAPLER=stapler~%string FLASHLIGHT=flashlight~%string FLASHLIGHT_UP=flashlight_up~%string DOOR=door~%string DOOR_UNLOCK=door_unlock~%string BOTTLE=bottle~%string MAGLITE=maglite~%string MAGLITE_UP=maglite_up~%string MAGLITE_DOWN=maglite_down~%string MAGLITE_LYING=maglite_lying~%string RADIO=radio~%string HANDSET=handset~%string HANDSET_DOWN=handset_down~%string CRADLE=cradle~%string CRADLE_FLAT=cradle_flat~%string CRADLE_VERTICAL=cradle_vertical~%string SCREWDRIVER=screwdriver~%string DRILL=drill~%string DRILL_UPRIGHT=drill_upright~%string DRILL_BLOCK=drill_block~%string DRILL_BLOCK_LYING=drill_block_lying~%string DRILL_BLOCK_STANDING=drill_block_standing~%string RED_DOT=red_dot~%string SHOVEL=shovel~%string SHOVEL_FLAT=shovel_flat~%string SHOVEL_ONEDGE=shovel_onedge~%string HAMMER=hammer~%string HAMMER_DOWN=hammer_down~%string HAMMER_LYING=hammer_lying~%string HAMMER_UP=hammer_up~%string HAMMER_ONEDGE=hammer_onedge~%string FLOODLIGHT=floodlight~%string FLOODLIGHT_SIDE=floodlight_side~%string FLOODLIGHT_DOWN=floodlight_down~%string PELICAN=pelican~%string PELICAN_HANDLE_UP=pelican_handle_up~%string PELICAN_LABEL_UP=pelican_label_up~%string PELICAN_LABEL_DOWN=pelican_label_down~%string PELICAN_LEFT_EDGE_DOWN=pelican_left_edge_down~%string PELICAN_RIGHT_EDGE_DOWN=pelican_right_edge_down~%geometry_msgs/PoseWithCovarianceStamped pose~%~%================================================================================~%MSG: geometry_msgs/PoseWithCovarianceStamped~%# This expresses an estimated pose with a reference coordinate frame and timestamp~%~%Header header~%PoseWithCovariance pose~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/PoseWithCovariance~%# This represents a pose in free space with uncertainty.~%~%Pose pose~%~%# Row-major representation of the 6x6 covariance matrix~%# The orientation parameters use a fixed-axis representation.~%# In order, the parameters are:~%# (x, y, z, rotation about X axis, rotation about Y axis, rotation about Z axis)~%float64[36] covariance~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of postion and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'FindObject-response)))
  "Returns full string definition for message of type 'FindObject-response"
  (cl:format cl:nil "bool found~%arm_msgs/Object object~%~%~%================================================================================~%MSG: arm_msgs/Object~%string name~%string ORANGE_PAPER=orange_paper~%string BALL=ball~%string ROCK=rock~%string CANTEEN=canteen~%string CANTEEN_STANDING=canteen_standing~%string CANTEEN_LYING=canteen_lying~%string PVC_PIPE_BIG=pipe~%string PVC_PIPE_BIG_STANDING=pipe_standing~%string PVC_PIPE_BIG_LYING=pipe_lying~%string STAPLER=stapler~%string FLASHLIGHT=flashlight~%string FLASHLIGHT_UP=flashlight_up~%string DOOR=door~%string DOOR_UNLOCK=door_unlock~%string BOTTLE=bottle~%string MAGLITE=maglite~%string MAGLITE_UP=maglite_up~%string MAGLITE_DOWN=maglite_down~%string MAGLITE_LYING=maglite_lying~%string RADIO=radio~%string HANDSET=handset~%string HANDSET_DOWN=handset_down~%string CRADLE=cradle~%string CRADLE_FLAT=cradle_flat~%string CRADLE_VERTICAL=cradle_vertical~%string SCREWDRIVER=screwdriver~%string DRILL=drill~%string DRILL_UPRIGHT=drill_upright~%string DRILL_BLOCK=drill_block~%string DRILL_BLOCK_LYING=drill_block_lying~%string DRILL_BLOCK_STANDING=drill_block_standing~%string RED_DOT=red_dot~%string SHOVEL=shovel~%string SHOVEL_FLAT=shovel_flat~%string SHOVEL_ONEDGE=shovel_onedge~%string HAMMER=hammer~%string HAMMER_DOWN=hammer_down~%string HAMMER_LYING=hammer_lying~%string HAMMER_UP=hammer_up~%string HAMMER_ONEDGE=hammer_onedge~%string FLOODLIGHT=floodlight~%string FLOODLIGHT_SIDE=floodlight_side~%string FLOODLIGHT_DOWN=floodlight_down~%string PELICAN=pelican~%string PELICAN_HANDLE_UP=pelican_handle_up~%string PELICAN_LABEL_UP=pelican_label_up~%string PELICAN_LABEL_DOWN=pelican_label_down~%string PELICAN_LEFT_EDGE_DOWN=pelican_left_edge_down~%string PELICAN_RIGHT_EDGE_DOWN=pelican_right_edge_down~%geometry_msgs/PoseWithCovarianceStamped pose~%~%================================================================================~%MSG: geometry_msgs/PoseWithCovarianceStamped~%# This expresses an estimated pose with a reference coordinate frame and timestamp~%~%Header header~%PoseWithCovariance pose~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/PoseWithCovariance~%# This represents a pose in free space with uncertainty.~%~%Pose pose~%~%# Row-major representation of the 6x6 covariance matrix~%# The orientation parameters use a fixed-axis representation.~%# In order, the parameters are:~%# (x, y, z, rotation about X axis, rotation about Y axis, rotation about Z axis)~%float64[36] covariance~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of postion and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <FindObject-response>))
  (cl:+ 0
     1
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'object))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <FindObject-response>))
  "Converts a ROS message object to a list"
  (cl:list 'FindObject-response
    (cl:cons ':found (found msg))
    (cl:cons ':object (object msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'FindObject)))
  'FindObject-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'FindObject)))
  'FindObject-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'FindObject)))
  "Returns string type for a service object of type '<FindObject>"
  "arm_msgs/FindObject")
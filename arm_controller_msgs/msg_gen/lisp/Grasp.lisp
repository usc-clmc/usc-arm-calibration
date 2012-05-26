; Auto-generated. Do not edit!


(cl:in-package arm_controller_msgs-msg)


;//! \htmlinclude Grasp.msg.html

(cl:defclass <Grasp> (roslisp-msg-protocol:ros-message)
  ((command
    :reader command
    :initarg :command
    :type cl:integer
    :initform 0)
   (desired_grasp_force
    :reader desired_grasp_force
    :initarg :desired_grasp_force
    :type (cl:vector cl:float)
   :initform (cl:make-array 3 :element-type 'cl:float :initial-element 0.0)))
)

(cl:defclass Grasp (<Grasp>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Grasp>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Grasp)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-msg:<Grasp> is deprecated: use arm_controller_msgs-msg:Grasp instead.")))

(cl:ensure-generic-function 'command-val :lambda-list '(m))
(cl:defmethod command-val ((m <Grasp>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:command-val is deprecated.  Use arm_controller_msgs-msg:command instead.")
  (command m))

(cl:ensure-generic-function 'desired_grasp_force-val :lambda-list '(m))
(cl:defmethod desired_grasp_force-val ((m <Grasp>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:desired_grasp_force-val is deprecated.  Use arm_controller_msgs-msg:desired_grasp_force instead.")
  (desired_grasp_force m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<Grasp>)))
    "Constants for message type '<Grasp>"
  '((:GRASP . 0)
    (:RELEASE . 1)
    (:R_RF . 0)
    (:R_MF . 1)
    (:R_LF . 2))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'Grasp)))
    "Constants for message type 'Grasp"
  '((:GRASP . 0)
    (:RELEASE . 1)
    (:R_RF . 0)
    (:R_MF . 1)
    (:R_LF . 2))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Grasp>) ostream)
  "Serializes a message object of type '<Grasp>"
  (cl:let* ((signed (cl:slot-value msg 'command)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'desired_grasp_force))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Grasp>) istream)
  "Deserializes a message object of type '<Grasp>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'command) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  (cl:setf (cl:slot-value msg 'desired_grasp_force) (cl:make-array 3))
  (cl:let ((vals (cl:slot-value msg 'desired_grasp_force)))
    (cl:dotimes (i 3)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:aref vals i) (roslisp-utils:decode-double-float-bits bits)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Grasp>)))
  "Returns string type for a message object of type '<Grasp>"
  "arm_controller_msgs/Grasp")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Grasp)))
  "Returns string type for a message object of type 'Grasp"
  "arm_controller_msgs/Grasp")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Grasp>)))
  "Returns md5sum for a message object of type '<Grasp>"
  "3b660fe2a9f73b778968b500bed89e45")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Grasp)))
  "Returns md5sum for a message object of type 'Grasp"
  "3b660fe2a9f73b778968b500bed89e45")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Grasp>)))
  "Returns full string definition for message of type '<Grasp>"
  (cl:format cl:nil "# The command type~%int32 command~%~%# constants that correspond to the commands~%int32 GRASP=0~%int32 RELEASE=1~%~%# grasp parameters~%float64[3] desired_grasp_force~%~%~%#indexing~%int32 R_RF=0~%int32 R_MF=1~%int32 R_LF=2~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Grasp)))
  "Returns full string definition for message of type 'Grasp"
  (cl:format cl:nil "# The command type~%int32 command~%~%# constants that correspond to the commands~%int32 GRASP=0~%int32 RELEASE=1~%~%# grasp parameters~%float64[3] desired_grasp_force~%~%~%#indexing~%int32 R_RF=0~%int32 R_MF=1~%int32 R_LF=2~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Grasp>))
  (cl:+ 0
     4
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'desired_grasp_force) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Grasp>))
  "Converts a ROS message object to a list"
  (cl:list 'Grasp
    (cl:cons ':command (command msg))
    (cl:cons ':desired_grasp_force (desired_grasp_force msg))
))

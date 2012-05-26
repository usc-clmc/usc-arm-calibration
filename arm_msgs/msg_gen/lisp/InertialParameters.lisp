; Auto-generated. Do not edit!


(cl:in-package arm_msgs-msg)


;//! \htmlinclude InertialParameters.msg.html

(cl:defclass <InertialParameters> (roslisp-msg-protocol:ros-message)
  ((mass
    :reader mass
    :initarg :mass
    :type cl:float
    :initform 0.0)
   (cog
    :reader cog
    :initarg :cog
    :type geometry_msgs-msg:Vector3
    :initform (cl:make-instance 'geometry_msgs-msg:Vector3))
   (inertia_tensor
    :reader inertia_tensor
    :initarg :inertia_tensor
    :type (cl:vector cl:float)
   :initform (cl:make-array 6 :element-type 'cl:float :initial-element 0.0)))
)

(cl:defclass InertialParameters (<InertialParameters>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <InertialParameters>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'InertialParameters)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_msgs-msg:<InertialParameters> is deprecated: use arm_msgs-msg:InertialParameters instead.")))

(cl:ensure-generic-function 'mass-val :lambda-list '(m))
(cl:defmethod mass-val ((m <InertialParameters>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-msg:mass-val is deprecated.  Use arm_msgs-msg:mass instead.")
  (mass m))

(cl:ensure-generic-function 'cog-val :lambda-list '(m))
(cl:defmethod cog-val ((m <InertialParameters>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-msg:cog-val is deprecated.  Use arm_msgs-msg:cog instead.")
  (cog m))

(cl:ensure-generic-function 'inertia_tensor-val :lambda-list '(m))
(cl:defmethod inertia_tensor-val ((m <InertialParameters>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_msgs-msg:inertia_tensor-val is deprecated.  Use arm_msgs-msg:inertia_tensor instead.")
  (inertia_tensor m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <InertialParameters>) ostream)
  "Serializes a message object of type '<InertialParameters>"
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'mass))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'cog) ostream)
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'inertia_tensor))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <InertialParameters>) istream)
  "Deserializes a message object of type '<InertialParameters>"
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'mass) (roslisp-utils:decode-double-float-bits bits)))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'cog) istream)
  (cl:setf (cl:slot-value msg 'inertia_tensor) (cl:make-array 6))
  (cl:let ((vals (cl:slot-value msg 'inertia_tensor)))
    (cl:dotimes (i 6)
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
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<InertialParameters>)))
  "Returns string type for a message object of type '<InertialParameters>"
  "arm_msgs/InertialParameters")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'InertialParameters)))
  "Returns string type for a message object of type 'InertialParameters"
  "arm_msgs/InertialParameters")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<InertialParameters>)))
  "Returns md5sum for a message object of type '<InertialParameters>"
  "75bb54439c911c53bebd7796cc0842a0")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'InertialParameters)))
  "Returns md5sum for a message object of type 'InertialParameters"
  "75bb54439c911c53bebd7796cc0842a0")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<InertialParameters>)))
  "Returns full string definition for message of type '<InertialParameters>"
  (cl:format cl:nil "##inertial parameters needed to define a rigid object~%float64 mass~%geometry_msgs/Vector3 cog~%~%## since it is symmetric we represent only the first 6 elements of the inertia tensor~%## in order I11, I12, I13, I22, I23, I33~%float64[6] inertia_tensor  ~%~%================================================================================~%MSG: geometry_msgs/Vector3~%# This represents a vector in free space. ~%~%float64 x~%float64 y~%float64 z~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'InertialParameters)))
  "Returns full string definition for message of type 'InertialParameters"
  (cl:format cl:nil "##inertial parameters needed to define a rigid object~%float64 mass~%geometry_msgs/Vector3 cog~%~%## since it is symmetric we represent only the first 6 elements of the inertia tensor~%## in order I11, I12, I13, I22, I23, I33~%float64[6] inertia_tensor  ~%~%================================================================================~%MSG: geometry_msgs/Vector3~%# This represents a vector in free space. ~%~%float64 x~%float64 y~%float64 z~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <InertialParameters>))
  (cl:+ 0
     8
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'cog))
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'inertia_tensor) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <InertialParameters>))
  "Converts a ROS message object to a list"
  (cl:list 'InertialParameters
    (cl:cons ':mass (mass msg))
    (cl:cons ':cog (cog msg))
    (cl:cons ':inertia_tensor (inertia_tensor msg))
))

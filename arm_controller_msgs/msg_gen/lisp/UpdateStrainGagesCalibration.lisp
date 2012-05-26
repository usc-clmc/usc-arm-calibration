; Auto-generated. Do not edit!


(cl:in-package arm_controller_msgs-msg)


;//! \htmlinclude UpdateStrainGagesCalibration.msg.html

(cl:defclass <UpdateStrainGagesCalibration> (roslisp-msg-protocol:ros-message)
  ((offsets
    :reader offsets
    :initarg :offsets
    :type (cl:vector cl:float)
   :initform (cl:make-array 3 :element-type 'cl:float :initial-element 0.0))
   (slopes
    :reader slopes
    :initarg :slopes
    :type (cl:vector cl:float)
   :initform (cl:make-array 3 :element-type 'cl:float :initial-element 0.0)))
)

(cl:defclass UpdateStrainGagesCalibration (<UpdateStrainGagesCalibration>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <UpdateStrainGagesCalibration>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'UpdateStrainGagesCalibration)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_controller_msgs-msg:<UpdateStrainGagesCalibration> is deprecated: use arm_controller_msgs-msg:UpdateStrainGagesCalibration instead.")))

(cl:ensure-generic-function 'offsets-val :lambda-list '(m))
(cl:defmethod offsets-val ((m <UpdateStrainGagesCalibration>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:offsets-val is deprecated.  Use arm_controller_msgs-msg:offsets instead.")
  (offsets m))

(cl:ensure-generic-function 'slopes-val :lambda-list '(m))
(cl:defmethod slopes-val ((m <UpdateStrainGagesCalibration>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_controller_msgs-msg:slopes-val is deprecated.  Use arm_controller_msgs-msg:slopes instead.")
  (slopes m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <UpdateStrainGagesCalibration>) ostream)
  "Serializes a message object of type '<UpdateStrainGagesCalibration>"
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'offsets))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'slopes))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <UpdateStrainGagesCalibration>) istream)
  "Deserializes a message object of type '<UpdateStrainGagesCalibration>"
  (cl:setf (cl:slot-value msg 'offsets) (cl:make-array 3))
  (cl:let ((vals (cl:slot-value msg 'offsets)))
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
  (cl:setf (cl:slot-value msg 'slopes) (cl:make-array 3))
  (cl:let ((vals (cl:slot-value msg 'slopes)))
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
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<UpdateStrainGagesCalibration>)))
  "Returns string type for a message object of type '<UpdateStrainGagesCalibration>"
  "arm_controller_msgs/UpdateStrainGagesCalibration")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'UpdateStrainGagesCalibration)))
  "Returns string type for a message object of type 'UpdateStrainGagesCalibration"
  "arm_controller_msgs/UpdateStrainGagesCalibration")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<UpdateStrainGagesCalibration>)))
  "Returns md5sum for a message object of type '<UpdateStrainGagesCalibration>"
  "9ea971c21839a0c80c442ca4d7d78661")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'UpdateStrainGagesCalibration)))
  "Returns md5sum for a message object of type 'UpdateStrainGagesCalibration"
  "9ea971c21839a0c80c442ca4d7d78661")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<UpdateStrainGagesCalibration>)))
  "Returns full string definition for message of type '<UpdateStrainGagesCalibration>"
  (cl:format cl:nil "##message containing the new strain gages calibration infos~%~%#each an array of 24 touch values~%float64[3] offsets~%float64[3] slopes~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'UpdateStrainGagesCalibration)))
  "Returns full string definition for message of type 'UpdateStrainGagesCalibration"
  (cl:format cl:nil "##message containing the new strain gages calibration infos~%~%#each an array of 24 touch values~%float64[3] offsets~%float64[3] slopes~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <UpdateStrainGagesCalibration>))
  (cl:+ 0
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'offsets) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'slopes) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <UpdateStrainGagesCalibration>))
  "Converts a ROS message object to a list"
  (cl:list 'UpdateStrainGagesCalibration
    (cl:cons ':offsets (offsets msg))
    (cl:cons ':slopes (slopes msg))
))

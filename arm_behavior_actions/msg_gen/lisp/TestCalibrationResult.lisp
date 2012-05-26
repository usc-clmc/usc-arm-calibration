; Auto-generated. Do not edit!


(cl:in-package arm_behavior_actions-msg)


;//! \htmlinclude TestCalibrationResult.msg.html

(cl:defclass <TestCalibrationResult> (roslisp-msg-protocol:ros-message)
  ((mean
    :reader mean
    :initarg :mean
    :type geometry_msgs-msg:Point
    :initform (cl:make-instance 'geometry_msgs-msg:Point))
   (variance
    :reader variance
    :initarg :variance
    :type geometry_msgs-msg:Point
    :initform (cl:make-instance 'geometry_msgs-msg:Point))
   (result
    :reader result
    :initarg :result
    :type cl:integer
    :initform 0)
   (info
    :reader info
    :initarg :info
    :type cl:string
    :initform ""))
)

(cl:defclass TestCalibrationResult (<TestCalibrationResult>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <TestCalibrationResult>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'TestCalibrationResult)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm_behavior_actions-msg:<TestCalibrationResult> is deprecated: use arm_behavior_actions-msg:TestCalibrationResult instead.")))

(cl:ensure-generic-function 'mean-val :lambda-list '(m))
(cl:defmethod mean-val ((m <TestCalibrationResult>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_behavior_actions-msg:mean-val is deprecated.  Use arm_behavior_actions-msg:mean instead.")
  (mean m))

(cl:ensure-generic-function 'variance-val :lambda-list '(m))
(cl:defmethod variance-val ((m <TestCalibrationResult>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_behavior_actions-msg:variance-val is deprecated.  Use arm_behavior_actions-msg:variance instead.")
  (variance m))

(cl:ensure-generic-function 'result-val :lambda-list '(m))
(cl:defmethod result-val ((m <TestCalibrationResult>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_behavior_actions-msg:result-val is deprecated.  Use arm_behavior_actions-msg:result instead.")
  (result m))

(cl:ensure-generic-function 'info-val :lambda-list '(m))
(cl:defmethod info-val ((m <TestCalibrationResult>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm_behavior_actions-msg:info-val is deprecated.  Use arm_behavior_actions-msg:info instead.")
  (info m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<TestCalibrationResult>)))
    "Constants for message type '<TestCalibrationResult>"
  '((:FAILED . 0)
    (:SUCCEEDED . 1))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'TestCalibrationResult)))
    "Constants for message type 'TestCalibrationResult"
  '((:FAILED . 0)
    (:SUCCEEDED . 1))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <TestCalibrationResult>) ostream)
  "Serializes a message object of type '<TestCalibrationResult>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'mean) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'variance) ostream)
  (cl:let* ((signed (cl:slot-value msg 'result)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'info))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'info))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <TestCalibrationResult>) istream)
  "Deserializes a message object of type '<TestCalibrationResult>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'mean) istream)
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'variance) istream)
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'result) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'info) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'info) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<TestCalibrationResult>)))
  "Returns string type for a message object of type '<TestCalibrationResult>"
  "arm_behavior_actions/TestCalibrationResult")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'TestCalibrationResult)))
  "Returns string type for a message object of type 'TestCalibrationResult"
  "arm_behavior_actions/TestCalibrationResult")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<TestCalibrationResult>)))
  "Returns md5sum for a message object of type '<TestCalibrationResult>"
  "31bc32dacf8cc1e1e3165ed79640a4df")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'TestCalibrationResult)))
  "Returns md5sum for a message object of type 'TestCalibrationResult"
  "31bc32dacf8cc1e1e3165ed79640a4df")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<TestCalibrationResult>)))
  "Returns full string definition for message of type '<TestCalibrationResult>"
  (cl:format cl:nil "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======~%# Define the result~%geometry_msgs/Point mean~%geometry_msgs/Point variance~%int32 result~%int32 FAILED=0~%int32 SUCCEEDED=1~%string info~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'TestCalibrationResult)))
  "Returns full string definition for message of type 'TestCalibrationResult"
  (cl:format cl:nil "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======~%# Define the result~%geometry_msgs/Point mean~%geometry_msgs/Point variance~%int32 result~%int32 FAILED=0~%int32 SUCCEEDED=1~%string info~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <TestCalibrationResult>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'mean))
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'variance))
     4
     4 (cl:length (cl:slot-value msg 'info))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <TestCalibrationResult>))
  "Converts a ROS message object to a list"
  (cl:list 'TestCalibrationResult
    (cl:cons ':mean (mean msg))
    (cl:cons ':variance (variance msg))
    (cl:cons ':result (result msg))
    (cl:cons ':info (info msg))
))

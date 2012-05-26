; Auto-generated. Do not edit!


(cl:in-package SafetyLight_msgs-msg)


;//! \htmlinclude SetColor.msg.html

(cl:defclass <SetColor> (roslisp-msg-protocol:ros-message)
  ((r
    :reader r
    :initarg :r
    :type cl:fixnum
    :initform 0)
   (g
    :reader g
    :initarg :g
    :type cl:fixnum
    :initform 0)
   (b
    :reader b
    :initarg :b
    :type cl:fixnum
    :initform 0))
)

(cl:defclass SetColor (<SetColor>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SetColor>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SetColor)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name SafetyLight_msgs-msg:<SetColor> is deprecated: use SafetyLight_msgs-msg:SetColor instead.")))

(cl:ensure-generic-function 'r-val :lambda-list '(m))
(cl:defmethod r-val ((m <SetColor>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader SafetyLight_msgs-msg:r-val is deprecated.  Use SafetyLight_msgs-msg:r instead.")
  (r m))

(cl:ensure-generic-function 'g-val :lambda-list '(m))
(cl:defmethod g-val ((m <SetColor>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader SafetyLight_msgs-msg:g-val is deprecated.  Use SafetyLight_msgs-msg:g instead.")
  (g m))

(cl:ensure-generic-function 'b-val :lambda-list '(m))
(cl:defmethod b-val ((m <SetColor>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader SafetyLight_msgs-msg:b-val is deprecated.  Use SafetyLight_msgs-msg:b instead.")
  (b m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SetColor>) ostream)
  "Serializes a message object of type '<SetColor>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'r)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'g)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'b)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SetColor>) istream)
  "Deserializes a message object of type '<SetColor>"
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'r)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'g)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'b)) (cl:read-byte istream))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SetColor>)))
  "Returns string type for a message object of type '<SetColor>"
  "SafetyLight_msgs/SetColor")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SetColor)))
  "Returns string type for a message object of type 'SetColor"
  "SafetyLight_msgs/SetColor")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SetColor>)))
  "Returns md5sum for a message object of type '<SetColor>"
  "353891e354491c51aabe32df673fb446")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SetColor)))
  "Returns md5sum for a message object of type 'SetColor"
  "353891e354491c51aabe32df673fb446")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SetColor>)))
  "Returns full string definition for message of type '<SetColor>"
  (cl:format cl:nil "#~%# COPYRIGHT (C) 2005-2010~%# RE2, INC.~%# ALL RIGHTS RESERVED~%#~%# This is free software:~%# you can redistribute it and/or modify it under the terms of the GNU General~%# Public License as published by the Free Software Foundation, either version~%# 3 of the License, or (at your option) any later version.~%#~%# You should have received a copy of the GNU General Public License along~%# with this package.  If not, see <http://www.gnu.org/licenses/>.~%#~%# RE2, INC. disclaims all warranties with regard to this software, including~%# all implied warranties of merchantability and fitness, in no event shall~%# RE2, INC. be liable for any special, indirect or consequential damages or~%# any damages whatsoever resulting from loss of use, data or profits, whether~%# in an action of contract, negligence or other tortious action, arising out~%# of or in connection with the use or performance of this software.~%#~%#~%#~%~%# Set the color of the safety light.  It is set as a red green blue triple.~%~%uint8 r~%uint8 g~%uint8 b~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SetColor)))
  "Returns full string definition for message of type 'SetColor"
  (cl:format cl:nil "#~%# COPYRIGHT (C) 2005-2010~%# RE2, INC.~%# ALL RIGHTS RESERVED~%#~%# This is free software:~%# you can redistribute it and/or modify it under the terms of the GNU General~%# Public License as published by the Free Software Foundation, either version~%# 3 of the License, or (at your option) any later version.~%#~%# You should have received a copy of the GNU General Public License along~%# with this package.  If not, see <http://www.gnu.org/licenses/>.~%#~%# RE2, INC. disclaims all warranties with regard to this software, including~%# all implied warranties of merchantability and fitness, in no event shall~%# RE2, INC. be liable for any special, indirect or consequential damages or~%# any damages whatsoever resulting from loss of use, data or profits, whether~%# in an action of contract, negligence or other tortious action, arising out~%# of or in connection with the use or performance of this software.~%#~%#~%#~%~%# Set the color of the safety light.  It is set as a red green blue triple.~%~%uint8 r~%uint8 g~%uint8 b~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SetColor>))
  (cl:+ 0
     1
     1
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SetColor>))
  "Converts a ROS message object to a list"
  (cl:list 'SetColor
    (cl:cons ':r (r msg))
    (cl:cons ':g (g msg))
    (cl:cons ':b (b msg))
))

; Auto-generated. Do not edit!


(cl:in-package SafetyLight_msgs-msg)


;//! \htmlinclude SetGreen.msg.html

(cl:defclass <SetGreen> (roslisp-msg-protocol:ros-message)
  ((status
    :reader status
    :initarg :status
    :type cl:boolean
    :initform cl:nil))
)

(cl:defclass SetGreen (<SetGreen>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SetGreen>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SetGreen)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name SafetyLight_msgs-msg:<SetGreen> is deprecated: use SafetyLight_msgs-msg:SetGreen instead.")))

(cl:ensure-generic-function 'status-val :lambda-list '(m))
(cl:defmethod status-val ((m <SetGreen>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader SafetyLight_msgs-msg:status-val is deprecated.  Use SafetyLight_msgs-msg:status instead.")
  (status m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SetGreen>) ostream)
  "Serializes a message object of type '<SetGreen>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'status) 1 0)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SetGreen>) istream)
  "Deserializes a message object of type '<SetGreen>"
    (cl:setf (cl:slot-value msg 'status) (cl:not (cl:zerop (cl:read-byte istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SetGreen>)))
  "Returns string type for a message object of type '<SetGreen>"
  "SafetyLight_msgs/SetGreen")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SetGreen)))
  "Returns string type for a message object of type 'SetGreen"
  "SafetyLight_msgs/SetGreen")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SetGreen>)))
  "Returns md5sum for a message object of type '<SetGreen>"
  "3a1255d4d998bd4d6585c64639b5ee9a")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SetGreen)))
  "Returns md5sum for a message object of type 'SetGreen"
  "3a1255d4d998bd4d6585c64639b5ee9a")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SetGreen>)))
  "Returns full string definition for message of type '<SetGreen>"
  (cl:format cl:nil "#~%# COPYRIGHT (C) 2005-2010~%# RE2, INC.~%# ALL RIGHTS RESERVED~%#~%# This is free software:~%# you can redistribute it and/or modify it under the terms of the GNU General~%# Public License as published by the Free Software Foundation, either version~%# 3 of the License, or (at your option) any later version.~%#~%# You should have received a copy of the GNU General Public License along~%# with this package.  If not, see <http://www.gnu.org/licenses/>.~%#~%# RE2, INC. disclaims all warranties with regard to this software, including~%# all implied warranties of merchantability and fitness, in no event shall~%# RE2, INC. be liable for any special, indirect or consequential damages or~%# any damages whatsoever resulting from loss of use, data or profits, whether~%# in an action of contract, negligence or other tortious action, arising out~%# of or in connection with the use or performance of this software.~%#~%#~%#~%~%# Set the status of the green value on the safety light~%~%# True is on, false is off~%bool status~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SetGreen)))
  "Returns full string definition for message of type 'SetGreen"
  (cl:format cl:nil "#~%# COPYRIGHT (C) 2005-2010~%# RE2, INC.~%# ALL RIGHTS RESERVED~%#~%# This is free software:~%# you can redistribute it and/or modify it under the terms of the GNU General~%# Public License as published by the Free Software Foundation, either version~%# 3 of the License, or (at your option) any later version.~%#~%# You should have received a copy of the GNU General Public License along~%# with this package.  If not, see <http://www.gnu.org/licenses/>.~%#~%# RE2, INC. disclaims all warranties with regard to this software, including~%# all implied warranties of merchantability and fitness, in no event shall~%# RE2, INC. be liable for any special, indirect or consequential damages or~%# any damages whatsoever resulting from loss of use, data or profits, whether~%# in an action of contract, negligence or other tortious action, arising out~%# of or in connection with the use or performance of this software.~%#~%#~%#~%~%# Set the status of the green value on the safety light~%~%# True is on, false is off~%bool status~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SetGreen>))
  (cl:+ 0
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SetGreen>))
  "Converts a ROS message object to a list"
  (cl:list 'SetGreen
    (cl:cons ':status (status msg))
))

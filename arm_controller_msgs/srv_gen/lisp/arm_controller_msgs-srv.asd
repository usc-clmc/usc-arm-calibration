
(cl:in-package :asdf)

(defsystem "arm_controller_msgs-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :arm_controller_msgs-msg
)
  :components ((:file "_package")
    (:file "QueryControllerStatus" :depends-on ("_package_QueryControllerStatus"))
    (:file "_package_QueryControllerStatus" :depends-on ("_package"))
    (:file "SwitchControllerStack" :depends-on ("_package_SwitchControllerStack"))
    (:file "_package_SwitchControllerStack" :depends-on ("_package"))
  ))
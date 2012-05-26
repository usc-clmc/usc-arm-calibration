
(cl:in-package :asdf)

(defsystem "arm_msgs-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :geometry_msgs-msg
)
  :components ((:file "_package")
    (:file "InertialParameters" :depends-on ("_package_InertialParameters"))
    (:file "_package_InertialParameters" :depends-on ("_package"))
    (:file "Task" :depends-on ("_package_Task"))
    (:file "_package_Task" :depends-on ("_package"))
    (:file "Objects" :depends-on ("_package_Objects"))
    (:file "_package_Objects" :depends-on ("_package"))
    (:file "Object" :depends-on ("_package_Object"))
    (:file "_package_Object" :depends-on ("_package"))
    (:file "Tasks" :depends-on ("_package_Tasks"))
    (:file "_package_Tasks" :depends-on ("_package"))
    (:file "BoundingBox" :depends-on ("_package_BoundingBox"))
    (:file "_package_BoundingBox" :depends-on ("_package"))
    (:file "StatusReport" :depends-on ("_package_StatusReport"))
    (:file "_package_StatusReport" :depends-on ("_package"))
  ))
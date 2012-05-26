
(cl:in-package :asdf)

(defsystem "SafetyLight_msgs-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "SetRed" :depends-on ("_package_SetRed"))
    (:file "_package_SetRed" :depends-on ("_package"))
    (:file "SetGreen" :depends-on ("_package_SetGreen"))
    (:file "_package_SetGreen" :depends-on ("_package"))
    (:file "SetColor" :depends-on ("_package_SetColor"))
    (:file "_package_SetColor" :depends-on ("_package"))
    (:file "SetYellow" :depends-on ("_package_SetYellow"))
    (:file "_package_SetYellow" :depends-on ("_package"))
  ))
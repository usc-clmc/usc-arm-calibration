
(cl:in-package :asdf)

(defsystem "arm_calibrate_extrinsics-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "CalibrateExtrinsics" :depends-on ("_package_CalibrateExtrinsics"))
    (:file "_package_CalibrateExtrinsics" :depends-on ("_package"))
  ))
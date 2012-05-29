
(cl:in-package :asdf)

(defsystem "arm_calibrate_extrinsics-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :ar_target-msg
               :geometry_msgs-msg
               :sensor_msgs-msg
               :std_msgs-msg
)
  :components ((:file "_package")
    (:file "ARFrame3d" :depends-on ("_package_ARFrame3d"))
    (:file "_package_ARFrame3d" :depends-on ("_package"))
    (:file "ARFrame" :depends-on ("_package_ARFrame"))
    (:file "_package_ARFrame" :depends-on ("_package"))
  ))
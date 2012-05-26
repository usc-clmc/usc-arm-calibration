
(cl:in-package :asdf)

(defsystem "usc_utilities-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "AccumulatedTrialStatistics" :depends-on ("_package_AccumulatedTrialStatistics"))
    (:file "_package_AccumulatedTrialStatistics" :depends-on ("_package"))
  ))
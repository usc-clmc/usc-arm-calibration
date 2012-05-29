FILE(REMOVE_RECURSE
  "../msg_gen"
  "../src/arm_controller_msgs/msg"
  "../msg_gen"
  "CMakeFiles/ROSBUILD_genmsg_cpp"
  "../msg_gen/cpp/include/arm_controller_msgs/ResetBreakaway.h"
  "../msg_gen/cpp/include/arm_controller_msgs/CalibrateForceTorqueSensorStatus.h"
  "../msg_gen/cpp/include/arm_controller_msgs/FingerForceControlGains.h"
  "../msg_gen/cpp/include/arm_controller_msgs/CalibratePressureSensorsStatus.h"
  "../msg_gen/cpp/include/arm_controller_msgs/GraspStatus.h"
  "../msg_gen/cpp/include/arm_controller_msgs/PressureSensors.h"
  "../msg_gen/cpp/include/arm_controller_msgs/ControllerStatus.h"
  "../msg_gen/cpp/include/arm_controller_msgs/UpdateStrainGagesCalibration.h"
  "../msg_gen/cpp/include/arm_controller_msgs/Grasp.h"
  "../msg_gen/cpp/include/arm_controller_msgs/Acceleration.h"
  "../msg_gen/cpp/include/arm_controller_msgs/ResetBreakawayStatus.h"
  "../msg_gen/cpp/include/arm_controller_msgs/CalibratePressureSensors.h"
  "../msg_gen/cpp/include/arm_controller_msgs/CalibrateForceTorqueSensor.h"
  "../msg_gen/cpp/include/arm_controller_msgs/StrainGauge.h"
  "../msg_gen/cpp/include/arm_controller_msgs/EndEffectorState.h"
  "../msg_gen/cpp/include/arm_controller_msgs/IncreaseMaxFingerTorque.h"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_genmsg_cpp.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

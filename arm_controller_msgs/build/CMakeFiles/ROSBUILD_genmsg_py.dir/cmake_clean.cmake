FILE(REMOVE_RECURSE
  "../msg_gen"
  "../src/arm_controller_msgs/msg"
  "../msg_gen"
  "CMakeFiles/ROSBUILD_genmsg_py"
  "../src/arm_controller_msgs/msg/__init__.py"
  "../src/arm_controller_msgs/msg/_FingerForceControlGains.py"
  "../src/arm_controller_msgs/msg/_CalibrateForceTorqueSensorStatus.py"
  "../src/arm_controller_msgs/msg/_CalibrateForceTorqueSensor.py"
  "../src/arm_controller_msgs/msg/_StrainGauge.py"
  "../src/arm_controller_msgs/msg/_CalibratePressureSensorsStatus.py"
  "../src/arm_controller_msgs/msg/_ControllerStatus.py"
  "../src/arm_controller_msgs/msg/_ResetBreakawayStatus.py"
  "../src/arm_controller_msgs/msg/_IncreaseMaxFingerTorque.py"
  "../src/arm_controller_msgs/msg/_Acceleration.py"
  "../src/arm_controller_msgs/msg/_UpdateStrainGagesCalibration.py"
  "../src/arm_controller_msgs/msg/_EndEffectorState.py"
  "../src/arm_controller_msgs/msg/_GraspStatus.py"
  "../src/arm_controller_msgs/msg/_Grasp.py"
  "../src/arm_controller_msgs/msg/_CalibratePressureSensors.py"
  "../src/arm_controller_msgs/msg/_ResetBreakaway.py"
  "../src/arm_controller_msgs/msg/_PressureSensors.py"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_genmsg_py.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

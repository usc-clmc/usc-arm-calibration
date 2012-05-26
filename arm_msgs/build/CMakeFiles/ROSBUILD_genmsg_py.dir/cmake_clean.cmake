FILE(REMOVE_RECURSE
  "../msg_gen"
  "../srv_gen"
  "../src/arm_msgs/msg"
  "../src/arm_msgs/srv"
  "../msg_gen"
  "../srv_gen"
  "CMakeFiles/ROSBUILD_genmsg_py"
  "../src/arm_msgs/msg/__init__.py"
  "../src/arm_msgs/msg/_InertialParameters.py"
  "../src/arm_msgs/msg/_Task.py"
  "../src/arm_msgs/msg/_Objects.py"
  "../src/arm_msgs/msg/_Object.py"
  "../src/arm_msgs/msg/_Tasks.py"
  "../src/arm_msgs/msg/_BoundingBox.py"
  "../src/arm_msgs/msg/_StatusReport.py"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_genmsg_py.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

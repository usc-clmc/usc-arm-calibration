FILE(REMOVE_RECURSE
  "../msg_gen"
  "../src/arm_head_control/msg"
  "../msg_gen"
  "CMakeFiles/ROSBUILD_genmsg_py"
  "../src/arm_head_control/msg/__init__.py"
  "../src/arm_head_control/msg/_LookAtAction.py"
  "../src/arm_head_control/msg/_LookAtGoal.py"
  "../src/arm_head_control/msg/_LookAtActionGoal.py"
  "../src/arm_head_control/msg/_LookAtResult.py"
  "../src/arm_head_control/msg/_LookAtActionResult.py"
  "../src/arm_head_control/msg/_LookAtFeedback.py"
  "../src/arm_head_control/msg/_LookAtActionFeedback.py"
  "../msg/LookAtAction.msg"
  "../msg/LookAtGoal.msg"
  "../msg/LookAtActionGoal.msg"
  "../msg/LookAtResult.msg"
  "../msg/LookAtActionResult.msg"
  "../msg/LookAtFeedback.msg"
  "../msg/LookAtActionFeedback.msg"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_genmsg_py.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

FILE(REMOVE_RECURSE
  "../msg_gen"
  "../src/arm_head_control/msg"
  "../msg_gen"
  "CMakeFiles/ROSBUILD_genaction_msgs"
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
  INCLUDE(CMakeFiles/ROSBUILD_genaction_msgs.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

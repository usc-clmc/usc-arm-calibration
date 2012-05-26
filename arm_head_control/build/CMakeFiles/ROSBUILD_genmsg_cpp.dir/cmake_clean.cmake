FILE(REMOVE_RECURSE
  "../msg_gen"
  "../src/arm_head_control/msg"
  "../msg_gen"
  "CMakeFiles/ROSBUILD_genmsg_cpp"
  "../msg_gen/cpp/include/arm_head_control/LookAtAction.h"
  "../msg_gen/cpp/include/arm_head_control/LookAtGoal.h"
  "../msg_gen/cpp/include/arm_head_control/LookAtActionGoal.h"
  "../msg_gen/cpp/include/arm_head_control/LookAtResult.h"
  "../msg_gen/cpp/include/arm_head_control/LookAtActionResult.h"
  "../msg_gen/cpp/include/arm_head_control/LookAtFeedback.h"
  "../msg_gen/cpp/include/arm_head_control/LookAtActionFeedback.h"
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
  INCLUDE(CMakeFiles/ROSBUILD_genmsg_cpp.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

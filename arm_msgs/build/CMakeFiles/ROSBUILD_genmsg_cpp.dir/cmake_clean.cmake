FILE(REMOVE_RECURSE
  "../msg_gen"
  "../srv_gen"
  "../src/arm_msgs/msg"
  "../src/arm_msgs/srv"
  "../msg_gen"
  "../srv_gen"
  "CMakeFiles/ROSBUILD_genmsg_cpp"
  "../msg_gen/cpp/include/arm_msgs/InertialParameters.h"
  "../msg_gen/cpp/include/arm_msgs/Task.h"
  "../msg_gen/cpp/include/arm_msgs/Objects.h"
  "../msg_gen/cpp/include/arm_msgs/Object.h"
  "../msg_gen/cpp/include/arm_msgs/Tasks.h"
  "../msg_gen/cpp/include/arm_msgs/BoundingBox.h"
  "../msg_gen/cpp/include/arm_msgs/StatusReport.h"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_genmsg_cpp.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

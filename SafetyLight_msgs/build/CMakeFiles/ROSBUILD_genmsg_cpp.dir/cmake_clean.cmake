FILE(REMOVE_RECURSE
  "../msg_gen"
  "../src/SafetyLight_msgs/msg"
  "../msg_gen"
  "CMakeFiles/ROSBUILD_genmsg_cpp"
  "../msg_gen/cpp/include/SafetyLight_msgs/SetColor.h"
  "../msg_gen/cpp/include/SafetyLight_msgs/SetGreen.h"
  "../msg_gen/cpp/include/SafetyLight_msgs/SetRed.h"
  "../msg_gen/cpp/include/SafetyLight_msgs/SetYellow.h"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_genmsg_cpp.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

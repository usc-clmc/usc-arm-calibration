FILE(REMOVE_RECURSE
  "../msg_gen"
  "../srv_gen"
  "../src/arm_msgs/msg"
  "../src/arm_msgs/srv"
  "../msg_gen"
  "../srv_gen"
  "CMakeFiles/ROSBUILD_gensrv_cpp"
  "../srv_gen/cpp/include/arm_msgs/FindObjectMulti.h"
  "../srv_gen/cpp/include/arm_msgs/FindObject.h"
  "../srv_gen/cpp/include/arm_msgs/GetTableCoeffs.h"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_gensrv_cpp.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

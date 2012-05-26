FILE(REMOVE_RECURSE
  "../msg_gen"
  "../srv_gen"
  "../src/arm_calibrate_extrinsics/msg"
  "../src/arm_calibrate_extrinsics/srv"
  "../msg_gen"
  "../srv_gen"
  "CMakeFiles/ROSBUILD_genmsg_cpp"
  "../msg_gen/cpp/include/arm_calibrate_extrinsics/ARFrame.h"
  "../msg_gen/cpp/include/arm_calibrate_extrinsics/ARFrame3d.h"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_genmsg_cpp.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

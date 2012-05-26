FILE(REMOVE_RECURSE
  "../msg_gen"
  "../src/ar_target/msg"
  "../msg_gen"
  "CMakeFiles/ROSBUILD_genmsg_cpp"
  "../msg_gen/cpp/include/ar_target/ARMarker.h"
  "../msg_gen/cpp/include/ar_target/ARMarkers3d.h"
  "../msg_gen/cpp/include/ar_target/ARMarker3d.h"
  "../msg_gen/cpp/include/ar_target/ARMarkers.h"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_genmsg_cpp.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

FILE(REMOVE_RECURSE
  "../msg_gen"
  "../srv_gen"
  "../src/arm_calibrate_extrinsics/msg"
  "../src/arm_calibrate_extrinsics/srv"
  "../msg_gen"
  "../srv_gen"
  "CMakeFiles/ROSBUILD_genmsg_py"
  "../src/arm_calibrate_extrinsics/msg/__init__.py"
  "../src/arm_calibrate_extrinsics/msg/_ARFrame3d.py"
  "../src/arm_calibrate_extrinsics/msg/_ARFrame.py"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_genmsg_py.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

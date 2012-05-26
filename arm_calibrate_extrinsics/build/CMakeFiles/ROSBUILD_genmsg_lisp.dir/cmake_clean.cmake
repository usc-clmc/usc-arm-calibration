FILE(REMOVE_RECURSE
  "../msg_gen"
  "../srv_gen"
  "../src/arm_calibrate_extrinsics/msg"
  "../src/arm_calibrate_extrinsics/srv"
  "../msg_gen"
  "../srv_gen"
  "CMakeFiles/ROSBUILD_genmsg_lisp"
  "../msg_gen/lisp/ARFrame.lisp"
  "../msg_gen/lisp/_package.lisp"
  "../msg_gen/lisp/_package_ARFrame.lisp"
  "../msg_gen/lisp/ARFrame3d.lisp"
  "../msg_gen/lisp/_package.lisp"
  "../msg_gen/lisp/_package_ARFrame3d.lisp"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_genmsg_lisp.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

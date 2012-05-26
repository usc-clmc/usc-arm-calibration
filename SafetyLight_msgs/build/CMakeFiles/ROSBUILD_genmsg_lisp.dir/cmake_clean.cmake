FILE(REMOVE_RECURSE
  "../msg_gen"
  "../src/SafetyLight_msgs/msg"
  "../msg_gen"
  "CMakeFiles/ROSBUILD_genmsg_lisp"
  "../msg_gen/lisp/SetRed.lisp"
  "../msg_gen/lisp/_package.lisp"
  "../msg_gen/lisp/_package_SetRed.lisp"
  "../msg_gen/lisp/SetGreen.lisp"
  "../msg_gen/lisp/_package.lisp"
  "../msg_gen/lisp/_package_SetGreen.lisp"
  "../msg_gen/lisp/SetColor.lisp"
  "../msg_gen/lisp/_package.lisp"
  "../msg_gen/lisp/_package_SetColor.lisp"
  "../msg_gen/lisp/SetYellow.lisp"
  "../msg_gen/lisp/_package.lisp"
  "../msg_gen/lisp/_package_SetYellow.lisp"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_genmsg_lisp.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

FILE(REMOVE_RECURSE
  "../msg_gen"
  "../srv_gen"
  "../src/arm_msgs/msg"
  "../src/arm_msgs/srv"
  "../msg_gen"
  "../srv_gen"
  "CMakeFiles/ROSBUILD_gensrv_lisp"
  "../srv_gen/lisp/FindObjectMulti.lisp"
  "../srv_gen/lisp/_package.lisp"
  "../srv_gen/lisp/_package_FindObjectMulti.lisp"
  "../srv_gen/lisp/FindObject.lisp"
  "../srv_gen/lisp/_package.lisp"
  "../srv_gen/lisp/_package_FindObject.lisp"
  "../srv_gen/lisp/GetTableCoeffs.lisp"
  "../srv_gen/lisp/_package.lisp"
  "../srv_gen/lisp/_package_GetTableCoeffs.lisp"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_gensrv_lisp.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

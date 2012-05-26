FILE(REMOVE_RECURSE
  "../msg_gen"
  "../srv_gen"
  "../src/arm_msgs/msg"
  "../src/arm_msgs/srv"
  "../msg_gen"
  "../srv_gen"
  "CMakeFiles/ROSBUILD_gensrv_py"
  "../src/arm_msgs/srv/__init__.py"
  "../src/arm_msgs/srv/_FindObjectMulti.py"
  "../src/arm_msgs/srv/_FindObject.py"
  "../src/arm_msgs/srv/_GetTableCoeffs.py"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_gensrv_py.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

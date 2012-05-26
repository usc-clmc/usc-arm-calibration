FILE(REMOVE_RECURSE
  "../msg_gen"
  "../src/SafetyLight_msgs/msg"
  "../msg_gen"
  "CMakeFiles/ROSBUILD_genmsg_py"
  "../src/SafetyLight_msgs/msg/__init__.py"
  "../src/SafetyLight_msgs/msg/_SetRed.py"
  "../src/SafetyLight_msgs/msg/_SetGreen.py"
  "../src/SafetyLight_msgs/msg/_SetColor.py"
  "../src/SafetyLight_msgs/msg/_SetYellow.py"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_genmsg_py.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

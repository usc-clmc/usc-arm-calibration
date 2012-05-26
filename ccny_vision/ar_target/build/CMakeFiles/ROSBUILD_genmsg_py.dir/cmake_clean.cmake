FILE(REMOVE_RECURSE
  "../msg_gen"
  "../src/ar_target/msg"
  "../msg_gen"
  "CMakeFiles/ROSBUILD_genmsg_py"
  "../src/ar_target/msg/__init__.py"
  "../src/ar_target/msg/_ARMarker.py"
  "../src/ar_target/msg/_ARMarkers3d.py"
  "../src/ar_target/msg/_ARMarker3d.py"
  "../src/ar_target/msg/_ARMarkers.py"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_genmsg_py.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

FILE(REMOVE_RECURSE
  "../msg_gen"
  "../src/usc_utilities/msg"
  "../msg_gen"
  "CMakeFiles/ROSBUILD_genmsg_py"
  "../src/usc_utilities/msg/__init__.py"
  "../src/usc_utilities/msg/_AccumulatedTrialStatistics.py"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_genmsg_py.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

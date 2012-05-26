FILE(REMOVE_RECURSE
  "CMakeFiles/ROSBUILD_gencfg_cpp"
  "../cfg/cpp/arm_honeybee/HoneybeeConfig.h"
  "../docs/HoneybeeConfig.dox"
  "../docs/HoneybeeConfig-usage.dox"
  "../src/arm_honeybee/cfg/HoneybeeConfig.py"
  "../docs/HoneybeeConfig.wikidoc"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_gencfg_cpp.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)

cmake_minimum_required(VERSION 2.4.6)
include($ENV{ROS_ROOT}/core/rosbuild/rosbuild.cmake)

# Set the build type.  Options are:
#  Coverage       : w/ debug symbols, w/o optimization, w/ code-coverage
#  Debug          : w/ debug symbols, w/o optimization
#  Release        : w/o debug symbols, w/ optimization
#  RelWithDebInfo : w/ debug symbols, w/ optimization
#  MinSizeRel     : w/o debug symbols, w/ optimization, stripped binaries
#set(ROS_BUILD_TYPE RelWithDebInfo)

rosbuild_find_ros_package(actionlib_msgs)
include(${actionlib_msgs_PACKAGE_PATH}/cmake/actionbuild.cmake)
genaction()

rosbuild_init()

#set the default path for built executables to the "bin" directory
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
#set the default path for built libraries to the "lib" directory
set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)

#uncomment if you have defined messages
rosbuild_genmsg()
#uncomment if you have defined services
#rosbuild_gensrv()

ADD_DEFINITIONS(-D_LINUX)
rosbuild_add_boost_directories()

rosbuild_add_executable(${PROJECT_NAME}
  src/arm_head_c_api.cpp
  src/arm_head_unit.cpp
  src/arm_pan_tilt_unit.cpp
  src/dp_pan_tilt_unit.cpp
  src/linuxser.c
  src/arm_head_control.cpp
)

#target_link_libraries(test_ptu arm_head_control)

rosbuild_link_boost(${PROJECT_NAME} thread)

#target_link_libraries(${PROJECT_NAME} another_library)
#rosbuild_add_boost_directories()
#rosbuild_link_boost(test_ptu thread)
#rosbuild_link_boost(arm_head_control thread)
#target_link_libraries(example ${PROJECT_NAME})

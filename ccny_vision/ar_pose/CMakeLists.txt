
cmake_minimum_required(VERSION 2.4.6)
include($ENV{ROS_ROOT}/core/rosbuild/rosbuild.cmake)

# Set the build type.  Options are:
#  Coverage       : w/ debug symbols, w/o optimization, w/ code-coverage
#  Debug          : w/ debug symbols, w/o optimization
#  Release        : w/o debug symbols, w/ optimization
#  RelWithDebInfo : w/ debug symbols, w/ optimization
#  MinSizeRel     : w/o debug symbols, w/ optimization, stripped binaries
#set(ROS_BUILD_TYPE RelWithDebInfo)
set(ROS_BUILD_TYPE Debug)

rosbuild_init()

#set the default path for built executables to the "bin" directory
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
#set the default path for built libraries to the "lib" directory
set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)

find_package(Eigen REQUIRED)
include_directories(${EIGEN_INCLUDE_DIRS})
add_definitions(${EIGEN_DEFINITIONS})

rosbuild_add_boost_directories()

#uncomment if you have defined messages
rosbuild_genmsg()
#uncomment if you have defined services
#rosbuild_gensrv()

# WARNING : The order of the libs matter !! 

include_directories(/usr/include/ /usr/src/linux/include/)
link_directories(/usr/lib/)

set(ARPOSESINGLE       ar_single)
set(ARPOSESINGLE_SRC   src/ar_single.cpp src/ar_base.cpp)
set(ARPOSESINGLE_LIBS  GLU GL glut ARgsub AR ARMulti ARvideo)

set(ARPOSEMULTI       ar_multi)
set(ARPOSEMULTI_SRC   src/ar_multi.cpp src/ar_base.cpp)
set(ARPOSEMULTI_LIBS   ARMulti ARgsub_lite ARgsubUtil ARgsub AR ARvideo GLU GL glut)

set(ARPOSEMULTIPLE_SINGLE       ar_multiple_single)
set(ARPOSEMULTIPLE_SINGLE_SRC   src/ar_multiple_single.cpp src/object.cpp src/ar_base.cpp)
set(ARPOSEMULTIPLE_SINGLE_LIBS  ARMulti ARgsub AR ARvideo ARgsub_lite ARgsubUtil GLU GL glut)

set(ARPOSEMK_PATT       mk_patt)
set(ARPOSEMK_PATT_SRC   src/mk_patt.cpp)
set(ARPOSEMK_PATT_LIBS  ARgsub ARgsub_lite ARvideo AR ARMulti ARgsubUtil GLU GL glut )

rosbuild_add_executable(${ARPOSESINGLE}  ${ARPOSESINGLE_SRC})
target_link_libraries(${ARPOSESINGLE}  ${ARPOSESINGLE_LIBS})

rosbuild_add_executable(${ARPOSEMULTIPLE_SINGLE}  ${ARPOSEMULTIPLE_SINGLE_SRC})
target_link_libraries(${ARPOSEMULTIPLE_SINGLE}  ${ARPOSEMULTIPLE_SINGLE_LIBS})

rosbuild_add_executable(${ARPOSEMULTI}  ${ARPOSEMULTI_SRC})
target_link_libraries(${ARPOSEMULTI}  ${ARPOSEMULTI_LIBS})

rosbuild_add_executable(${ARPOSEMK_PATT}  ${ARPOSEMK_PATT_SRC})
target_link_libraries(${ARPOSEMK_PATT}  ${ARPOSEMK_PATT_LIBS})

rosbuild_add_executable(ar_synchronize
  src/ar_synchronize.cpp
)

rosbuild_link_boost(ar_synchronize signals)


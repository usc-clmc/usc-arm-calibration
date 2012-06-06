cmake_minimum_required(VERSION 2.4.6)

project(arm_gp_lib)

include_directories(${CMAKE_SOURCE_DIR}/include)
add_library(arm_gp src/gp_model.cpp)

add_executable(test_head_gp src/test_head_gp.cpp)
target_link_libraries(test_head_gp arm_gp)

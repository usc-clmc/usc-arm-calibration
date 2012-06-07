#!/bin/bash
if [ -d build ]
then
  cd build
  cmake ..
  make clean
  rm -f ../libarm_gp.a
  rm -f ../test_head_gp
  cd ..
fi

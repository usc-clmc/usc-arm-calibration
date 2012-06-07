#!/bin/bash
if [ ! -d build ]
then
  mkdir build
fi

cd build
cmake ..
make
mv libarm_gp.a test_head_gp ..
cd ..

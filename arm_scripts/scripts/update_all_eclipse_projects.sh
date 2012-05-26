#!/bin/bash

echo "Updating eclipse project files for: "
echo $@

ALL_PROJECTS=`rospack depends $@`
ARM_SCRIPTS_DIR=`rospack find arm_scripts`

for i in $ALL_PROJECTS; do

DIR=`rospack find $i`
cd $DIR

if [ -f .cproject ]
then
  $ARM_SCRIPTS_DIR/scripts/create_eclipse_project
fi

done



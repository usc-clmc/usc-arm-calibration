#!/bin/bash
rosrun dynamic_reconfigure dynparam set /Honeybee auto_brightness true
rosrun dynamic_reconfigure dynparam set /Honeybee auto_exposure true
rosrun dynamic_reconfigure dynparam set /Honeybee auto_gain true
rosrun dynamic_reconfigure dynparam set /Honeybee auto_shutter true
rosrun dynamic_reconfigure dynparam set /Honeybee whitebalance auto

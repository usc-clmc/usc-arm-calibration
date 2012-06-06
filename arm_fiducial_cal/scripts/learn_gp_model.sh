#!/bin/bash
cd $(rospack find arm_fiducial_cal)/matlab
octave --silent learn_head_gp.m
octave --silent learn_head_gp_subset_cross_validate.m
cd -

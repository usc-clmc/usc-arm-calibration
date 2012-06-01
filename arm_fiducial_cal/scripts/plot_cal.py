#!/usr/bin/env python
import roslib; roslib.load_manifest('arm_fiducial_cal')
import sys
import numpy as np
from matplotlib import pyplot as plt
import yaml

correction_gp_filename = sys.argv[1]

# load corrections
corrections = yaml.load(open(correction_gp_filename).read())
gp_inputs = np.array(corrections['gp_training_inputs'])
gp_outputs = np.array(corrections['gp_training_outputs'])

fig = plt.figure()

N = gp_inputs.shape[1]
M = gp_outputs.shape[1]

axes = {}

for ii in range(N):
    for jj in range(M):
        sharex, sharey = None, None
        if ii > 0:
            sharex = axes[(0,jj)]
        if jj > 0:
            sharey = axes[(ii,0)]
            
        ax = fig.add_subplot(N, M, ii*M+jj+1, sharex=sharex, sharey=sharey)
        if sharex is not None:
            plt.setp(ax.get_xticklabels(), visible=False)
        if sharey is not None:
            plt.setp(ax.get_yticklabels(), visible=False)
        axes[(ii,jj)] = ax
        
        ax.plot(gp_inputs[:,ii], gp_outputs[:,jj], 'o')


            
plt.show()

import roslib; roslib.load_manifest('arm_fiducial_cal')
import numpy as np
import matplotlib
matplotlib.use('GTK')
from matplotlib import pyplot as plt
from scipy import linalg, optimize
import rospy
from tf import transformations
from sklearn import gaussian_process

from pier import store
from arm_fiducial_cal import FCOptimizer, FCFrame, FCViz, FCParams

def plot_gp(X, Y, gp, ax):
    x_min = np.min(X, axis=0)
    x_max = np.max(X, axis=0)
    X_pred = []

    padding = 0.5
    
    for x0 in np.linspace(x_min[0]-padding, x_max[0]+padding, 40):
        for x1 in np.linspace(x_min[1]-padding, x_max[1]+padding, 40):
            X_pred.append((x0, x1))
    X_pred = np.array(X_pred)

    Y_pred, mse_pred = gp.predict(X_pred, eval_MSE=True)

    print 'mse range = (%f, %f)' % (mse_pred.min(), mse_pred.max())
    C_mse = (mse_pred - mse_pred.min()) / (mse_pred.max() - mse_pred.min())

    print Y

    # normalize graph colors
    y_min = -0.08 # np.min(Y)
    y_max = 0.08 # np.max(Y)
    C = (Y - y_min) / (y_max - y_min)
    C_pred = (Y_pred - y_min) / (y_max - y_min)

    #ax.hist(Y_pred)
    ax.scatter(X[:,0], X[:,1], color=plt.cm.jet(C), marker='x', s=1000, linewidth=3)
    ax.scatter(X_pred[:,0], X_pred[:,1], color=plt.cm.jet(C_mse))

params = FCParams()
cache_dir = roslib.packages.get_pkg_subdir('arm_fiducial_cal', 'cache')
s = store.Store(cache_dir)
X = s['gp_training_inputs'][:,[0,2]]
training_outputs = s['gp_training_outputs']

gps = []
for d in range(training_outputs.shape[1])[:]:
    Y = training_outputs[:,d]
    gp = gaussian_process.GaussianProcess(theta0=1., thetaL=None, thetaU=None)
    gp.fit(X, Y)
    gps.append(gp)

titles = ['x', 'y', 'z', 'roll', 'pitch', 'yaw']

fig = plt.figure()
for d, gp in enumerate(gps):
    ax = fig.add_subplot(1, len(gps), d+1)
    plt.title(titles[d])
    Y = training_outputs[:,d]
    plot_gp(X, Y, gp, ax)
plt.show()

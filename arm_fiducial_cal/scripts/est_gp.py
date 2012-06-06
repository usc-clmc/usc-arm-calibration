d = 0
X = gp_training_inputs
Y = gp_training_outputs[:,d]
y_mean = Y.mean()
y_var = Y.var()
Y = (Y - y_mean) / y_var**0.5
gp = gaussian_process.GaussianProcess(
    regr='constant', beta0=0.0, normalize=False, theta0=1., thetaL=0.0001, thetaU=100000.)
gp.fit(X, Y)
correction_gps.append(gp)

load('predictions.mat');

fprintf('rms of errors before correction\n');
sqrt(mean(output.*output))
fprintf('rms of errors after correction\n');
corrected_output = all_test_output - output;
correction = sqrt(mean(corrected_output.*corrected_output))

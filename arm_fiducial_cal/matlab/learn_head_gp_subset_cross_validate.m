clear all;
% settings:
abs_training_input_fname = '../calib/correction_gp_input.txt';
abs_training_output_fname = '../calib/correction_gp_output.txt';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('gpml');
startup;

input = load(abs_training_input_fname);
output = load(abs_training_output_fname);
num_input_dim = size(input, 2);
num_output_dim = size(output, 2);

% do leave-one-out-cross-validation
num_points = size(input,1);

num_subsets = 20;

kfold_indices = crossvalind('Kfold', num_points, num_subsets);
training_inds = true(num_points,1);
for i=1:num_subsets
    
    training_inds(kfold_indices ~= i,1) = true;
    training_inds(kfold_indices == i,1) = false;

    training_input = input(training_inds, :);
    training_output = output(training_inds, :);
    
    test_input = input(kfold_indices  == i, :);
    real_test_output = output(kfold_indices  == i, :);
    test_output = zeros(size(real_test_output));
    
    [test_output, post, hyp, means, variances] = do_gp(training_input, training_output, test_input);
    all_test_output(kfold_indices  == i,:) = test_output;

end

save('predictions.mat','output','all_test_output');
evaluate_subset_cross_validation

% check nmse:
%nmse = var(test_output - real_test_output) ./ var(real_test_output);
%nmse = var(all_test_output - output) ./ var(output);
%nmse

%fprintf('std.dev. of errors before correction\n');
%mean(output)
%fprintf('std.dev. of errors after correction\n');
%mean(all_test_output - output)

%  [index trash] = size(plot_parameters.file_name);
%  color = plot_parameters.colors(index,:);
%  plot_error(1, color, pos_error, 'Position error', 'cm', position_error_range);
%  plot_abs_error(2, color, abs_pos_error, 'Absolute position error', 'm', position_error_range);
%  plot_error(3, color, quat_error, 'Quaternion error', 'deg', quat_error_range);
     

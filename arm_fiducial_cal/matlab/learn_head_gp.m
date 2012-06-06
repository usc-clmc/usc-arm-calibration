clear all;
% settings:
abs_training_input_fname = '../calib/correction_gp_input.txt';
abs_training_output_fname = '../calib/correction_gp_output.txt';
abs_model_output_fname = '../calib/models.txt';
%abs_test_data_fname = '../calib/test_data.txt';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('gpml');
startup;

input = load(abs_training_input_fname);
output = load(abs_training_output_fname);
num_input_dim = size(input, 2);
num_output_dim = size(output, 2);

[test_output, posteriors, hyper_params, means, variances] = do_gp(input, output, input);

fprintf('rms of errors');
sqrt(mean(output.*output))
fprintf('rms of corrected');
corrected_output = test_output - output;
sqrt(mean(corrected_output.*corrected_output))

fprintf('saving learnt models...');
f = fopen(abs_model_output_fname, 'w');
fprintf(f,'%d\t%d\n', num_input_dim, num_output_dim);
fprintf(f,'%d\n',size(input,1));
for j=1:size(input,1)
  for k=1:num_input_dim
    fprintf(f,'%f\t',input(j,k));
  end
  fprintf(f,'\n');
end

for i=1:num_output_dim
  fprintf(f,'%f\t',means(i));
  fprintf(f,'%f\t',variances(i));
  for j=1:num_input_dim
    fprintf(f,'%f\t',exp(hyper_params{i}.cov(j)));
  end
  fprintf(f,'%f\n',exp(hyper_params{i}.cov(num_input_dim+1)));
  for j=1:size(input,1)
    fprintf(f,'%f\n',posteriors{i}.alpha(j));
  end
end
fclose(f);
fprintf(' done!\n');


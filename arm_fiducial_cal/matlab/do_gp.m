function [test_output, post, hyp, means, variances] = do_gp(input, output_orig, test_input)

  % initial params:
  signal_stddev = 1.0;
  noise_stddev = 0.02;
  num_iter = 50;

  % remove mean from output
  means = mean(output_orig);
  mean_rep = repmat(means, size(output_orig,1), 1);
  output = output_orig - mean_rep;

  % normalize variance of output
  variances = var(output);
  variances(variances<1e-6) = 1e-6;
  var_rep = repmat(variances, size(output_orig,1), 1);
  output = output./var_rep;

  num_input_dim = size(input,2);
  num_output_dim = size(output,2);
  test_output = zeros(size(test_input,1), size(output,2));

  for i=1:num_output_dim

    %training_mean = {@meanSum,{@meanLinear,@meanConst}};
    training_mean = {@meanZero};
    %hyp0.mean = zeros(num_input_dim+1,1);
    training_covar = {@covSEard};
    hyp0.cov = [zeros(num_input_dim,1); log(signal_stddev * signal_stddev)];
    training_lik = @likGauss;
    hyp0.lik = log(noise_stddev);

    hyp{i} = minimize(hyp0, @gp, -num_iter, @infLOO, training_mean, training_covar, training_lik, input, output(:,i));

    % test outputs:
    [test_output(:,i) s2 fm fs2 lp post{i}] = gp(hyp{i}, @infLOO, training_mean, training_covar, training_lik, input, output(:,i), test_input);
  end
  test_output = (test_output.*repmat(variances,size(test_output,1),1)) + repmat(means, size(test_output,1), 1);
end


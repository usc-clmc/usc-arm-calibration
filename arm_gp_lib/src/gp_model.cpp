/*
 * gaussian_process_model.cpp
 *
 *  Created on: Sep 5, 2011
 *      Author: mrinal
 */

#include <arm_gp_lib/gp_model.h>
#include <fstream>
#include <cstdio>
#include <cmath>

namespace arm_gp_lib
{

GPModel::GPModel()
{
  model_loaded_ = false;
}

GPModel::~GPModel()
{
}

bool GPModel::readFromFile(const std::string& abs_file_name)
{
  std::ifstream f(abs_file_name.c_str());
  if (!f)
  {
    printf("GPModel: Couldn't open file %s.\n", abs_file_name.c_str());
    return false;
  }
  f >> num_input_dim_ >> num_output_dim_;

  printf("Reading GP model: %d input dimensions, %d output dimensions\n",
           num_input_dim_, num_output_dim_);

  f >> num_data_points_;
  data_points_.resize(num_data_points_, std::vector<double>(num_input_dim_));
  for (int nd=0; nd<num_data_points_; ++nd)
  {
    for (int id=0; id<num_input_dim_; ++id)
    {
      f >> data_points_[nd][id];
    }
  }

  gp_params_.resize(num_output_dim_);
  for (int od=0; od<num_output_dim_; ++od)
  {
    f >> gp_params_[od].mean;
    f >> gp_params_[od].variance;
    gp_params_[od].kernel_width.resize(num_input_dim_);
    for (int id=0; id<num_input_dim_; ++id)
    {
      f >> gp_params_[od].kernel_width[id];
    }
    f >> gp_params_[od].kernel_magnitude;

    gp_params_[od].alpha.resize(num_data_points_);
    for (int nd=0; nd<num_data_points_; ++nd)
    {
      f >> gp_params_[od].alpha[nd];
    }
  }
  f.close();

  model_loaded_ = true;

  return true;
}


void GPModel::evaluate(const std::vector<double>& input, std::vector<double>& output)
{
  output.clear();
  if (!model_loaded_)
  {
    printf("GPModel: Model not loaded!\n");
    return;
  }

  if (num_input_dim_ != input.size())
  {
    printf("GPModel: evaluate() called with wrong number of inputs\n");
    return;
  }

  output.resize(num_output_dim_, 0.0);

  for (int od=0; od<num_output_dim_; ++od)
  {
    // add up contributions from each data point
    for (int nd=0; nd<num_data_points_; ++nd)
    {
      // compute kernel
      double dist = 0.0;
      for (int id=0; id<num_input_dim_; ++id)
      {
        double diff = (input[id] - data_points_[nd][id])/gp_params_[od].kernel_width[id];
        dist += 0.5 * diff * diff;
      }
      double kernel = gp_params_[od].kernel_magnitude * gp_params_[od].kernel_magnitude * exp(-dist);
      output[od] += gp_params_[od].alpha[nd] * kernel;
    }
   
    // correct for output mean and variance
    output[od] = output[od]*gp_params_[od].variance + gp_params_[od].mean;
  }

}

int GPModel::getNumInputDimensions()
{
  return num_input_dim_;
}

int GPModel::getNumOutputDimensions()
{
  return num_output_dim_;
}

} /* namespace arm_gp_lib */

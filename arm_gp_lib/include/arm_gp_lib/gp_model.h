/*
 * gaussian_process_model.h
 *
 *  Created on: Sep 5, 2011
 *      Author: mrinal
 */

#ifndef GAUSSIAN_PROCESS_MODEL_H_
#define GAUSSIAN_PROCESS_MODEL_H_

#include <string>
#include <vector>

namespace arm_gp_lib
{

// params for each output dimension
struct GaussianProcessParameters
{
  double mean;
  double variance;
  std::vector<double> kernel_width; // num_inputs
  std::vector<double> alpha;        // num_data_points
  double kernel_magnitude;
};

class GPModel
{
public:
  GPModel();
  virtual ~GPModel();

  bool readFromFile(const std::string& abs_file_name);
  void evaluate(const std::vector<double>& input, std::vector<double>& output);
 
  int getNumInputDimensions();
  int getNumOutputDimensions();

private:
  int num_input_dim_;
  int num_output_dim_;

  std::vector<GaussianProcessParameters> gp_params_; // one for each output dimension
  int num_data_points_;
  std::vector<std::vector<double> > data_points_;

  bool model_loaded_;

};

} /* namespace arm_gp_lib */
#endif /* GAUSSIAN_PROCESS_MODEL_H_ */

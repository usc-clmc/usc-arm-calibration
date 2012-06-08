/*
 * verify_head_calibration.h
 *
 *  Created on: Jun 7, 2012
 *      Author: arm_user
 */

#ifndef VERIFY_HEAD_CALIBRATION_H_
#define VERIFY_HEAD_CALIBRATION_H_

#include <fstream>

#include <arm_gp_lib/gp_model.h>

#include <kdl/chainfksolverpos_recursive.hpp>
#include <usc_utilities/kdl_chain_wrapper.h>

namespace arm_calibrate_extrinsics
{

class VerifyHeadCalibration
{

public:

  VerifyHeadCalibration();
  virtual ~VerifyHeadCalibration() {};

  bool run();

private:

  bool generateHeadFK();

  void writeJointAngles(std::ofstream& joint_angle_file,
                        const double lpan, const double ltilt,
                        const double upan, const double utilt);

  void headFK(const double lpan, const double ltilt,
              const double upan, const double utilt,
              std::ofstream& forward_kinematic_file,
              usc_utilities::KDLChainWrapper& chain,
              bool do_correction = false,
              bool write_out_correction_only = false);

  arm_gp_lib::GPModel model_;

};

}




#endif /* VERIFY_HEAD_CALIBRATION_H_ */

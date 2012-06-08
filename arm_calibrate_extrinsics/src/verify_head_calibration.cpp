/*
 * verify_head_calibration.cpp
 *
 *  Created on: Jun 7, 2012
 *      Author: arm_user
 */

#include <ros/ros.h>

#include <usc_utilities/param_server.h>
#include <usc_utilities/assert.h>
#include <usc_utilities/file_io.h>

#include <ros/package.h>
#include <sstream>

#include <tf/transform_datatypes.h>
#include <arm_calibrate_extrinsics/verify_head_calibration.h>

namespace arm_calibrate_extrinsics
{

VerifyHeadCalibration::VerifyHeadCalibration()
{
}

bool VerifyHeadCalibration::run()
{
  return generateHeadFK();
}

bool VerifyHeadCalibration::generateHeadFK()
{

  KDL::JntArray kdl_joint_array;
  std::vector<std::string> joint_names;
  joint_names.push_back("LPAN");
  joint_names.push_back("LTILT");
  joint_names.push_back("UPAN");
  joint_names.push_back("UTILT");

  usc_utilities::KDLChainWrapper head_chain;
  head_chain.initialize("BASE", "HEAD");
  usc_utilities::KDLChainWrapper left_bb_chain;
  left_bb_chain.initialize("BASE", "BUMBLEBEE_LEFT_REAL");
  ROS_ASSERT(head_chain.getNumJoints() == left_bb_chain.getNumJoints());
  kdl_joint_array.resize(head_chain.getNumJoints());

  ROS_INFO("Initialized forward kinematic chain with >%d< joints.", head_chain.getNumJoints());

  std::string output_path = ros::package::getPath("arm_fiducial_cal");
  usc_utilities::appendTrailingSlash(output_path);

  std::string model_file = output_path + "calib/models.txt";
  ROS_VERIFY_MSG(model_.readFromFile(model_file), "Problems reading gp model file >%s<.", model_file.c_str());

  std::string input_file_name = output_path + "calib/verify_forward_kinematics_input.txt";
  std::ofstream joint_angle_file;
  joint_angle_file.open(input_file_name.c_str(), std::ios::out);
  if(!joint_angle_file.is_open())
  {
    ROS_ERROR("Could not open file >%s< to write out forward kinematic verification values.", input_file_name.c_str());
    return false;
  }

  std::string head_output_file_name = output_path + "calib/verify_forward_kinematics_head_output.txt";
  std::ofstream head_forward_kinematic_file;
  head_forward_kinematic_file.open(head_output_file_name.c_str(), std::ios::out);
  if(!head_forward_kinematic_file.is_open())
  {
    ROS_ERROR("Could not open file >%s< to write out forward kinematic verification values.", head_output_file_name.c_str());
    return false;
  }

  std::string left_bb_output_file_name = output_path + "calib/verify_forward_kinematics_left_bb_output.txt";
  std::ofstream left_bb_forward_kinematic_file;
  left_bb_forward_kinematic_file.open(left_bb_output_file_name.c_str(), std::ios::out);
  if(!left_bb_forward_kinematic_file.is_open())
  {
    ROS_ERROR("Could not open file >%s< to write out forward kinematic verification values.", left_bb_output_file_name.c_str());
    return false;
  }

  std::string gp_correction_output_file_name = output_path + "calib/verify_forward_kinematics_gp_correction_output.txt";
  std::ofstream gp_correction_forward_kinematic_file;
  gp_correction_forward_kinematic_file.open(gp_correction_output_file_name.c_str(), std::ios::out);
  if(!gp_correction_forward_kinematic_file.is_open())
  {
    ROS_ERROR("Could not open file >%s< to write out forward kinematic verification values.", gp_correction_output_file_name.c_str());
    return false;
  }

  std::string gp_output_file_name = output_path + "calib/verify_forward_kinematics_gp_corrections_only_output.txt";
  std::ofstream gp_correction_file;
  gp_correction_file.open(gp_output_file_name.c_str(), std::ios::out);
  if(!gp_correction_file.is_open())
  {
    ROS_ERROR("Could not open file >%s< to write out forward kinematic verification values.", gp_output_file_name.c_str());
    return false;
  }

  // std::vector<double> head_positions;
  // head_positions.resize(3+4, 0.0);

  const double LOWER_PAN_MIN = -2.9;
  const double LOWER_PAN_MAX = 2.9;
  const double LOWER_TILT_MIN = -1.22;
  const double LOWER_TILT_MAX = 1.22;
  const double UPPER_PAN_MIN = -1.3;
  const double UPPER_PAN_MAX = -0.0;
  const double UPPER_TILT_MIN = -1.55;
  const double UPPER_TILT_MAX = 1.55;

  writeJointAngles(joint_angle_file, 0.0, 0.0, 0.0, 0.0);
  writeJointAngles(joint_angle_file,LOWER_PAN_MIN, 0.0, 0.0, 0.0);
  writeJointAngles(joint_angle_file,LOWER_PAN_MAX, 0.0, 0.0, 0.0);
  writeJointAngles(joint_angle_file,0.0, LOWER_TILT_MIN, 0.0, 0.0);
  writeJointAngles(joint_angle_file,0.0, LOWER_TILT_MAX, 0.0, 0.0);
  writeJointAngles(joint_angle_file,0.0, 0.0, UPPER_PAN_MIN, 0.0);
  writeJointAngles(joint_angle_file,0.0, 0.0, UPPER_PAN_MAX, 0.0);
  writeJointAngles(joint_angle_file,0.0, 0.0, 0.0, UPPER_TILT_MIN);
  writeJointAngles(joint_angle_file,0.0, 0.0, 0.0, UPPER_TILT_MAX);

  headFK(0.0, 0.0, 0.0, 0.0, head_forward_kinematic_file, head_chain);
  headFK(LOWER_PAN_MIN, 0.0, 0.0, 0.0, head_forward_kinematic_file, head_chain);
  headFK(LOWER_PAN_MAX, 0.0, 0.0, 0.0, head_forward_kinematic_file, head_chain);
  headFK(0.0, LOWER_TILT_MIN, 0.0, 0.0, head_forward_kinematic_file, head_chain);
  headFK(0.0, LOWER_TILT_MAX, 0.0, 0.0, head_forward_kinematic_file, head_chain);
  headFK(0.0, 0.0, UPPER_PAN_MIN, 0.0, head_forward_kinematic_file, head_chain);
  headFK(0.0, 0.0, UPPER_PAN_MAX, 0.0, head_forward_kinematic_file, head_chain);
  headFK(0.0, 0.0, 0.0, UPPER_TILT_MIN, head_forward_kinematic_file, head_chain);
  headFK(0.0, 0.0, 0.0, UPPER_TILT_MAX, head_forward_kinematic_file, head_chain);

  headFK(0.0, 0.0, 0.0, 0.0, left_bb_forward_kinematic_file, left_bb_chain);
  headFK(LOWER_PAN_MIN, 0.0, 0.0, 0.0, left_bb_forward_kinematic_file, left_bb_chain);
  headFK(LOWER_PAN_MAX, 0.0, 0.0, 0.0, left_bb_forward_kinematic_file, left_bb_chain);
  headFK(0.0, LOWER_TILT_MIN, 0.0, 0.0, left_bb_forward_kinematic_file, left_bb_chain);
  headFK(0.0, LOWER_TILT_MAX, 0.0, 0.0, left_bb_forward_kinematic_file, left_bb_chain);
  headFK(0.0, 0.0, UPPER_PAN_MIN, 0.0, left_bb_forward_kinematic_file, left_bb_chain);
  headFK(0.0, 0.0, UPPER_PAN_MAX, 0.0, left_bb_forward_kinematic_file, left_bb_chain);
  headFK(0.0, 0.0, 0.0, UPPER_TILT_MIN, left_bb_forward_kinematic_file, left_bb_chain);
  headFK(0.0, 0.0, 0.0, UPPER_TILT_MAX, left_bb_forward_kinematic_file, left_bb_chain);

  headFK(0.0, 0.0, 0.0, 0.0, gp_correction_forward_kinematic_file, left_bb_chain, true);
  headFK(LOWER_PAN_MIN, 0.0, 0.0, 0.0, gp_correction_forward_kinematic_file, left_bb_chain, true);
  headFK(LOWER_PAN_MAX, 0.0, 0.0, 0.0, gp_correction_forward_kinematic_file, left_bb_chain, true);
  headFK(0.0, LOWER_TILT_MIN, 0.0, 0.0, gp_correction_forward_kinematic_file, left_bb_chain, true);
  headFK(0.0, LOWER_TILT_MAX, 0.0, 0.0, gp_correction_forward_kinematic_file, left_bb_chain, true);
  headFK(0.0, 0.0, UPPER_PAN_MIN, 0.0, gp_correction_forward_kinematic_file, left_bb_chain, true);
  headFK(0.0, 0.0, UPPER_PAN_MAX, 0.0, gp_correction_forward_kinematic_file, left_bb_chain, true);
  headFK(0.0, 0.0, 0.0, UPPER_TILT_MIN, gp_correction_forward_kinematic_file, left_bb_chain, true);
  headFK(0.0, 0.0, 0.0, UPPER_TILT_MAX, gp_correction_forward_kinematic_file, left_bb_chain, true);

  headFK(0.0, 0.0, 0.0, 0.0, gp_correction_file, left_bb_chain, true, true);
  headFK(LOWER_PAN_MIN, 0.0, 0.0, 0.0, gp_correction_file, left_bb_chain, true, true);
  headFK(LOWER_PAN_MAX, 0.0, 0.0, 0.0, gp_correction_file, left_bb_chain, true, true);
  headFK(0.0, LOWER_TILT_MIN, 0.0, 0.0, gp_correction_file, left_bb_chain, true, true);
  headFK(0.0, LOWER_TILT_MAX, 0.0, 0.0, gp_correction_file, left_bb_chain, true, true);
  headFK(0.0, 0.0, UPPER_PAN_MIN, 0.0, gp_correction_file, left_bb_chain, true, true);
  headFK(0.0, 0.0, UPPER_PAN_MAX, 0.0, gp_correction_file, left_bb_chain, true, true);
  headFK(0.0, 0.0, 0.0, UPPER_TILT_MIN, gp_correction_file, left_bb_chain, true, true);
  headFK(0.0, 0.0, 0.0, UPPER_TILT_MAX, gp_correction_file, left_bb_chain, true, true);

  const double increment = 0.2;
  double lower_pan = LOWER_PAN_MIN;
  while (lower_pan < LOWER_PAN_MAX - increment)
  {
    double lower_tilt = LOWER_TILT_MIN;
    while (lower_tilt < LOWER_TILT_MAX - increment)
    {
      double upper_pan = UPPER_PAN_MIN;
      while (upper_pan < UPPER_PAN_MAX - increment)
      {
        double upper_tilt = UPPER_TILT_MIN;
        while (upper_tilt < UPPER_TILT_MAX - increment)
        {

          writeJointAngles(joint_angle_file, lower_pan, lower_tilt, upper_pan, upper_tilt);
          headFK(lower_pan, lower_tilt, upper_pan, upper_tilt, head_forward_kinematic_file, head_chain);
          headFK(lower_pan, lower_tilt, upper_pan, upper_tilt, left_bb_forward_kinematic_file, left_bb_chain);
          headFK(lower_pan, lower_tilt, upper_pan, upper_tilt, gp_correction_forward_kinematic_file, left_bb_chain, true);
          headFK(lower_pan, lower_tilt, upper_pan, upper_tilt, gp_correction_file, left_bb_chain, true, true);

          upper_tilt += increment;
        }
        upper_pan += increment;
      }
      lower_tilt += increment;
    }
    lower_pan += increment;
  }

  joint_angle_file.close();
  head_forward_kinematic_file.close();
  left_bb_forward_kinematic_file.close();
  gp_correction_forward_kinematic_file.close();
  gp_correction_file.close();

  ROS_INFO("All done captain.");
  ROS_INFO("Files are stored in >%scalib<.", output_path.c_str());

  return true;
}

void VerifyHeadCalibration::writeJointAngles(std::ofstream& joint_angle_file,
                                             const double lpan, const double ltilt,
                                             const double upan, const double utilt)
{
  joint_angle_file << lpan;
  joint_angle_file <<  " ";
  joint_angle_file << ltilt;
  joint_angle_file <<  " ";
  joint_angle_file << upan;
  joint_angle_file <<  " ";
  joint_angle_file << utilt;
  joint_angle_file <<  "\n";
}

void VerifyHeadCalibration::headFK(const double lpan,
                                   const double ltilt,
                                   const double upan,
                                   const double utilt,
                                   std::ofstream& forward_kinematic_file,
                                   usc_utilities::KDLChainWrapper& chain,
                                   bool do_correction,
                                   bool write_out_correction_only)
{
  std::vector<double> joint_positions;
  joint_positions.resize(chain.getNumJoints(), 0.0);

  joint_positions[0] = lpan;
  joint_positions[1] = ltilt;
  joint_positions[2] = upan;
  joint_positions[3] = utilt;

  // compute fk
  KDL::JntArray kdl_joint_array;
  kdl_joint_array.resize(chain.getNumJoints());
  for (int i = 0; i < chain.getNumJoints(); ++i)
  {
    kdl_joint_array(i) = joint_positions[i];
  }
  KDL::Frame frame;
  chain.forwardKinematics(kdl_joint_array, frame);

  double x = frame.p.x();
  double y = frame.p.y();
  double z = frame.p.z();
  double qx = 0.0;
  double qy = 0.0;
  double qz = 0.0;
  double qw = 0.0;
  frame.M.GetQuaternion(qx, qy, qz, qw);

  if(do_correction)
  {
    std::vector<double> input;
    input.resize(model_.getNumInputDimensions(), 0.0);
    ROS_ASSERT(input.size() == joint_positions.size());
    for (int i = 0; i < model_.getNumInputDimensions(); ++i)
    {
      input[i] = joint_positions[i];
    }
    std::vector<double> output;
    output.resize(model_.getNumOutputDimensions(), 0.0);
    model_.evaluate(input, output);
    // ROS_INFO("%.3f %.3f %.3f %.3f %.3f %.3f", output[0], output[1], output[2], output[3], output[4], output[5]);

    if(write_out_correction_only)
    {
      for (int i = 0; i < (int)output.size(); ++i)
      {
        forward_kinematic_file << output[i];
        if (i + 1 == (int)output.size())
        {
          forward_kinematic_file << "\n";
        }
        else
        {
          forward_kinematic_file << " ";
        }
      }
      return;
    }

    // setup correcting transform
    tf::Matrix3x3 head_correcting_rotation;
    head_correcting_rotation.setRPY(output[3], output[4], output[5]);
    tf::Vector3 head_correcting_translation(output[0], output[1], output[2]);
    tf::Transform head_correction_transform(head_correcting_rotation, head_correcting_translation);

    tf::Transform base_to_bb;
    base_to_bb.setOrigin(tf::Vector3(x,y,z));
    base_to_bb.setRotation(tf::Quaternion(qx, qy, qz, qw));

    tf::Transform corrected_transform = base_to_bb * head_correction_transform;

    x = corrected_transform.getOrigin().getX();
    y = corrected_transform.getOrigin().getY();
    z = corrected_transform.getOrigin().getZ();
    qw = corrected_transform.getRotation().getW();
    qx = corrected_transform.getRotation().getX();
    qy = corrected_transform.getRotation().getY();
    qz = corrected_transform.getRotation().getZ();
    // ROS_INFO("%.3f %.3f %.3f %.3f %.3f %.3f %.3f", x,y,z,qw,qx,qy,qz);

  }

  // write to file
  forward_kinematic_file << x;
  forward_kinematic_file << " ";
  forward_kinematic_file << y;
  forward_kinematic_file << " ";
  forward_kinematic_file << z;
  forward_kinematic_file << " ";
  forward_kinematic_file << qw;
  forward_kinematic_file << " ";
  forward_kinematic_file << qx;
  forward_kinematic_file << " ";
  forward_kinematic_file << qy;
  forward_kinematic_file << " ";
  forward_kinematic_file << qz;
  forward_kinematic_file << "\n";
}

}

int main(int argc, char** argv)
{
  ros::init(argc, argv, "VerifyHeadCalibration");
  arm_calibrate_extrinsics::VerifyHeadCalibration verify_head_calibration;
  if(!verify_head_calibration.run())
  {
    for(int i=0; i<10; ++i)
      ROS_ERROR("Generating the head calibration files failed !");
  }
  return 0;
}

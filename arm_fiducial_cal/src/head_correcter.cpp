/*
 * head_correcter.cpp
 *
 *  Created on: Jun 6, 2012
 *      Author: arm_user
 */

#include <ros/package.h>
#include <usc_utilities/assert.h>
#include <usc_utilities/param_server.h>
#include <arm_fiducial_cal/head_correcter.h>

namespace arm_fiducial_cal
{

HeadCorrecter::HeadCorrecter(ros::NodeHandle node_handle)
  : node_handle_(node_handle), joint_map_initialized_(false)
{
  // generate absolute filename
  std::string arm_fiducial_cal_path = ros::package::getPath("arm_fiducial_cal");
  usc_utilities::appendTrailingSlash(arm_fiducial_cal_path);
  std::string file_name = arm_fiducial_cal_path + "calib/models.txt";

  // initialize the gp model
  ROS_VERIFY(gp_model_.readFromFile(file_name));

  // allocate some memory
  input_.resize(gp_model_.getNumInputDimensions(), 0.0);
  prev_input_.resize(gp_model_.getNumInputDimensions(), 0.0);
  output_.resize(gp_model_.getNumOutputDimensions(), 0.0);

  // setup the joint state subscriber
  joint_state_sub_ = node_handle_.subscribe("/joint_states", 300, &HeadCorrecter::jointStateCB, this);

  // set the frame ids (only once)
  corrected_head_transform_.child_frame_id_ = CORRECTED_HEAD_FRAME;
  corrected_head_transform_.frame_id_ = BASE_FRAME;

  // wait for the tf listener to fill its buffer.
  ros::Duration(2.0).sleep();
}

void HeadCorrecter::jointStateCB(const sensor_msgs::JointStateConstPtr joint_state)
{
  // compute the joint mapping once
  if(!joint_map_initialized_)
  {
    std::vector<std::string> joint_names;
    joint_names.push_back("LPAN");
    joint_names.push_back("LTILT");
    joint_names.push_back("UPAN");
    joint_names.push_back("UTILT");

    for (int i = 0; i < (int)joint_names.size(); ++i)
    {
      bool found = false;
      for (int j = 0; !found && j < (int)joint_state->name.size(); ++j)
      {
        if(joint_state->name[j].compare(joint_names[i]) == 0)
        {
          joint_map_.push_back(j);
          found = true;
        }
      }
      ROS_VERIFY_MSG(found, "Could not find joint named >%s<.", joint_names[i].c_str());
    }
    ROS_VERIFY_MSG(joint_map_.size() == input_.size(), "Joint map vector and input vector must be of same size.");
    joint_map_initialized_ = true;
    ROS_INFO("HeadCorrecter is online.");
  }

  // get the 4 joint angles
  for (int i = 0; i < (int)joint_map_.size(); ++i)
  {
    input_[i] = joint_state->position[joint_map_[i]];
  }

  double distance = 0.0;
  for (int i = 0; i < (int)input_.size(); ++i)
  {
    distance += fabs(prev_input_[i] - input_[i]);
  }

  // check whether joint angles changed significantly
  if(distance < 1e-8)
  {
    ROS_DEBUG("Skipping offset correction and publishing previous transform.");
  }
  else // computing new transform
  {
    // get predictions
    gp_model_.evaluate(input_, output_);
    ROS_INFO("input-->output : %.4f %.4f %.4f %.4f --> %.4f %.4f %.4f | %.4f %.4f %.4f",
             input_[0], input_[1], input_[2], input_[3],
             output_[0], output_[1], output_[2], output_[3], output_[4], output_[5]);

    // setup correcting transform
    tf::Matrix3x3 head_correcting_rotation;
    head_correcting_rotation.setRPY(output_[3], output_[4], output_[5]);
    tf::Vector3 head_correcting_translation(output_[0], output_[1], output_[2]);
    tf::Transform head_correction_transform(head_correcting_rotation, head_correcting_translation);

    // get base to (original) head transform
    tf::StampedTransform head_transform_base_stamped;
    try
    {
      if (!tf_listener_.waitForTransform(BASE_FRAME, ORIGINAL_HEAD_FRAME, joint_state->header.stamp, ros::Duration(0.1)))
      {
        ROS_WARN("Problems obtaining >%s< to >%s< transform. Trying again...", BASE_FRAME.c_str(), ORIGINAL_HEAD_FRAME.c_str());
        return;
      }
      tf_listener_.lookupTransform(BASE_FRAME, ORIGINAL_HEAD_FRAME, joint_state->header.stamp, head_transform_base_stamped);
    }
    catch (tf::TransformException& ex)
    {
      ROS_WARN_STREAM("Transform error from " << BASE_FRAME << " to " << ORIGINAL_HEAD_FRAME << ", quitting callback : " << ex.what() << ". Trying again...");
      return;
    }

    // compute corrected transform
    corrected_head_transform_.setData(head_transform_base_stamped * head_correction_transform);

    // cache joint angles
    prev_input_ = input_;
  }

  // set time stamp and publish tf transform
  corrected_head_transform_.stamp_ = joint_state->header.stamp;
  tf_broadcaster_.sendTransform(corrected_head_transform_);
}

}

int main(int argc, char** argv)
{
  ros::init(argc, argv, "HeadCorrector");
  ros::NodeHandle node_handle("~");
  arm_fiducial_cal::HeadCorrecter head_corrector(node_handle);
  ros::spin();
  return 0;
}

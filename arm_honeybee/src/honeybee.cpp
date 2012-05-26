/*
 *  honeybee.cpp
 *
 *  Created on: Nov 4, 2010
 *      Author: Jonathan Kelly
 */
#include <signal.h>
#include <boost/format.hpp>

// ROS
#include <ros/ros.h>
#include <camera_info_manager/camera_info_manager.h>
#include <driver_base/driver.h>
#include <driver_base/SensorLevels.h>
#include <dynamic_reconfigure/server.h>
#include <dynamic_reconfigure/SensorLevels.h>
#include <image_transport/image_transport.h>
#include <sensor_msgs/CameraInfo.h>
#include <sensor_msgs/image_encodings.h>
#include <tf/transform_listener.h>

// Local
#include "dev_bumblebee2.h"
#include "arm_honeybee/honeybeeConfig.h"

/** @file
 *
 *  @brief ARM driver node for Bumblebee 2 stereo camera.
 *
 *  This node provides a driver for the Point Grey Bumblebee 2 stereo
 *  camera (under IIDC Format 7).  The node relies on libdc1394.
 *
 *  @par Advertises
 *
 *   - @b Honeybee/left/image_raw (sensor_msgs/Image) Raw left stereo image.
 *
 *   - @b Honeybee/right/image_raw (sensor_msgs/Image) Raw right stereo image.
 *
 *   - @b Honeybee/left/camera_info (sensor_msgs/CameraInfo) Calibration
 *     information for left stereo camera.
 *
 *   - @b Honeybee/right/camera_info (sensor_msgs/CameraInfo) Calibration
 *     information for right stereo camera.
 */

namespace enc = sensor_msgs::image_encodings;
namespace cim = camera_info_manager;

typedef driver_base::Driver Driver;
typedef driver_base::SensorLevels Levels;

// Prototypes
void sigsegv_handler(int sig);


class HoneybeeNode
{
private:

  Driver::state_t state_;

  ros::NodeHandle priv_nh_;
  image_transport::ImageTransport* it_;

  std::string camera_name_;
  std::string frame_id_;

  sensor_msgs::Image left_image_;
  sensor_msgs::Image right_image_;

  sensor_msgs::CameraInfo left_cam_info_;
  sensor_msgs::CameraInfo right_cam_info_;

  std::string left_calib_url_;
  std::string right_calib_url_;

  cim::CameraInfoManager* left_cam_mgr_;
  cim::CameraInfoManager* right_cam_mgr_;

  // Standard parameters
  bool bus_reset_;
  std::string bayer_pattern_;
  std::string encoding_;
  std::string guid_;
  int iso_speed_;
  std::string video_mode_;

  arm_honeybee::Bumblebee2* dev_;

  // Dynamic parameter config message.
  arm_honeybee::honeybeeConfig config_;

  bool calibration_valid_;
  bool calibration_loaded_;

  image_transport::CameraPublisher left_image_pub_;
  image_transport::CameraPublisher right_image_pub_;

public:

  HoneybeeNode():
    state_(Driver::CLOSED),
    dev_(NULL),
    calibration_valid_(true),
    calibration_loaded_(false)
  {
    priv_nh_ = ros::NodeHandle("~");

    ros::NodeHandle leftNH(priv_nh_, "left");
    ros::NodeHandle rightNH(priv_nh_, "right");

    left_cam_mgr_  = new cim::CameraInfoManager(leftNH);
    right_cam_mgr_ = new cim::CameraInfoManager(rightNH);

    getInitParams();

    it_ = new image_transport::ImageTransport(priv_nh_);
    left_image_pub_  = it_->advertiseCamera("left/image_raw", 1);
    right_image_pub_ = it_->advertiseCamera("right/image_raw", 2);
  };

  ~HoneybeeNode()
  {
    delete left_cam_mgr_;
    delete right_cam_mgr_;
    delete it_;
  }

  void closeCamera()
  {
    if(state_ != Driver::CLOSED)
    {
      dev_->close();
      delete dev_;
      dev_ = NULL;

      state_ = Driver::CLOSED;
    }
  };

  // Get initial parameters (only when node starts).
  void getInitParams()
  {
    if(!priv_nh_.getParam("frame_id", frame_id_))
    {
      frame_id_ = "BUMBLEBEE_LEFT";
    }

    // Default name... replaced by GUID.
    camera_name_ = "Honeybee";

    // Resolve frame ID using tf_prefix parameter.
    std::string tf_prefix = tf::getPrefixParam(priv_nh_);
    frame_id_  = tf::resolve(tf_prefix, frame_id_);

    // Read other parameters.
    priv_nh_.param("guid", guid_, std::string("NONE"));
    priv_nh_.param("bus_reset", bus_reset_, true);
    priv_nh_.param("iso_speed", iso_speed_, 400);

    priv_nh_.param("left_calibration_url",  left_calib_url_,  std::string(""));
    priv_nh_.param("right_calibration_url", right_calib_url_, std::string(""));

    if(!left_cam_mgr_->validateURL(left_calib_url_) ||
       !right_cam_mgr_->validateURL(right_calib_url_))
    {
      ROS_WARN_STREAM("Left or right camera info URL is invalid."
          << " CameraInfo will indicate Bumblebee 2 is uncalibrated.");
      calibration_valid_ = false;
    }
  };

  /** Open the camera device.
   *
   *  If the open call succeeds, the driver state is set to OPENED and
   *  the camera_name_ is set to the GUID of the Bumblebee 2.
   *
   *  @param config new Config values.
   *
   *  @return true if successful
   */
  bool openCamera(arm_honeybee::honeybeeConfig &config)
  {
    bool success = false;
    int retries = 2;

    do
    {
      try
      {
        dev_ = new arm_honeybee::Bumblebee2();

        if(dev_->open(guid_.c_str(), config.fps, iso_speed_, bus_reset_) == 0)
        {
          if(camera_name_ != dev_->device_id_)
          {
            camera_name_ = dev_->device_id_;

            if(!left_cam_mgr_->setCameraName(camera_name_) ||
               !right_cam_mgr_->setCameraName(camera_name_))
            {
              // GUID is 16 hex digits, which should be valid.
              // If not, use it for log messages anyway.
              ROS_WARN_STREAM("[" << camera_name_
                  << "] camera name is not valid for camera info manager.");
            }
          }

          state_ = Driver::OPENED;
          success = true;
        }
      }
      catch(arm_honeybee::Exception& e)
      {
        if(retries > 0)
        {
          ROS_WARN_STREAM("[" << camera_name_
              << "] exception opening device (retrying): "
              << e.what());
        }
        else
        {
          ROS_ERROR_STREAM("[" << camera_name_ << "] device open failed.");
        }
      }
    }
    while(!success && --retries > 0);

    return success;
  };

  /** IIDC feature initialization.
   *
   *  Intializes available IIDC features on the Bumblebee2 when the
   *  device is first opened.
   *
   *  @param config initial config values.
   *
   *  @return true if the initialization is successful.
   */
  bool initializeFeatures(arm_honeybee::honeybeeConfig& config)
  {
    bool success = true;
    int exposure;
    float brightness, gain, shutter;

    // Brightness
    brightness = config.auto_brightness ? -1 : config.brightness;
    if(dev_->setBrightnessAbs(brightness) != 0)
      success = false;

    // Exposure
    exposure = config.auto_exposure ? -1 : config.exposure;
    if(dev_->setAutoExposure(exposure) != 0)
      success = false;

    // Gain
    gain = config.auto_gain ? -1 : config.gain;
    if(dev_->setGainAbs(gain) != 0)
      success = false;

    // Shutter
    shutter = config.auto_shutter ? -1 : config.shutter;
    if(dev_->setShutterAbs(shutter) != 0)
      success = false;

    // Whitebalance
    if(config.whitebalance == "")
      config.whitebalance = "auto";

    if(dev_->setWhiteBalance(config.whitebalance.c_str()) != 0)
      success = false;

    return success;
  };

  /** IIDC feature update.
   *
   *  Updates available IIDC features on the Bumblebee2 as part of
   *  a dynamic reconfigure call.
   *
   *  @param config updated config values.
   *
   *  @return true if the update is successful.
   */
  bool updateFeatures(arm_honeybee::honeybeeConfig& config)
  {
    bool success = true;
    int exposure;
    float brightness, gain, shutter;

    // Brightness
    if(  config_.auto_brightness != config.auto_brightness ||
       (!config_.auto_brightness && config_.brightness != config.brightness))
    {
      brightness = config.auto_brightness ? -1 : config.brightness;
      if(dev_->setBrightnessAbs(brightness) != 0)
      {
        success = false;
      }
      else
      {
        if(!config.auto_brightness)
          ROS_INFO_STREAM(
              "[" << camera_name_ << "] Brightness set to " << brightness);
        else
          ROS_INFO_STREAM("[" << camera_name_ << "] Auto Brightness");
      }
    }

    // Exposure
    if(  config_.auto_exposure != config.auto_exposure ||
       (!config_.auto_exposure && config_.exposure != config.exposure))
    {
      exposure = config.auto_exposure ? -1 : config.exposure;
      if(dev_->setAutoExposure(exposure) != 0)
      {
        success = false;
      }
      else
      {
        if(!config.auto_exposure)
          ROS_INFO_STREAM(
              "[" << camera_name_ << "] Exposure set to " << exposure);
        else
          ROS_INFO_STREAM("[" << camera_name_ << "] Auto Exposure");
      }
    }

    // Gain
    if(  config_.auto_gain != config.auto_gain ||
       (!config_.auto_gain && config_.gain != config.gain))
    {
      gain = config.auto_gain ? -1 : config.gain;
      if(dev_->setGainAbs(gain) != 0)
      {
        success = false;
      }
      else
      {
        if(!config.auto_gain)
          ROS_INFO_STREAM("[" << camera_name_ << "] Gain set to " << gain);
        else
          ROS_INFO_STREAM("[" << camera_name_ << "] Auto Gain");
      }
    }

    // Shutter
    if(  config_.auto_shutter != config.auto_shutter ||
       (!config_.auto_shutter && config_.shutter != config.shutter))
    {
      shutter = config.auto_shutter ? -1 : config.shutter;
      if(dev_->setShutterAbs(shutter) != 0)
      {
        success = false;
      }
      else
      {
        if(!config.auto_shutter)
          ROS_INFO_STREAM("[" << camera_name_ << "] Shutter set to "
              << shutter);
        else
          ROS_INFO_STREAM("[" << camera_name_ << "] Auto Shutter");
      }
    }

    // Whitebalance
    if(config_.whitebalance != config.whitebalance)
    {
      if(config.whitebalance == "")
        config.whitebalance = "auto";

      if(dev_->setWhiteBalance(config.whitebalance.c_str()) != 0)
      {
        success = false;
      }
      else
      {
        if(config.whitebalance != "auto")
          ROS_INFO_STREAM("[" << camera_name_ << "] Whitebalance set to "
              << config.whitebalance);
        else
          ROS_INFO_STREAM("[" << camera_name_ << "] Auto Whitebalance");
      }
    }

    return success;
  };

  /** Dynamic reconfigure callback.
   *
   *  Called immediately when callback is first bound. Called again
   *  when dynamic reconfigure starts up, or when a parameter value
   *  changes.
   *
   *  @param config new Config values.
   *  @param level  bit-wise OR of reconfiguration levels for all
   *                changed parameters (0xffffffff on initial call).
   */
  void reconfig(arm_honeybee::honeybeeConfig& config, uint32_t level)
  {
    ROS_DEBUG("Dynamic reconfigure level 0x%x.", level);

    if(state_ != Driver::CLOSED && (level & Levels::RECONFIGURE_CLOSE))
    {
      // Need to close the device before we can update these params.
      closeCamera();
    }

    if(state_ == Driver::CLOSED)
    {
      openCamera(config);

      // Load calibration data on startup (first open).
      if(calibration_valid_ && !calibration_loaded_)
      {
        left_cam_mgr_->loadCameraInfo(left_calib_url_);
        right_cam_mgr_->loadCameraInfo(right_calib_url_);
        calibration_loaded_ = true;
      }
    }

    // Update settings.
    if(state_ != Driver::CLOSED)
    {
      // Configure IIDC features.
      if(level & Levels::RECONFIGURE_CLOSE)
      {
        // Initialize features for newly opened device.
        if(!initializeFeatures(config))
        {
          ROS_ERROR_STREAM("[" << camera_name_
              << "] feature initialization failure");
          closeCamera();  // Epic fail...
        }
      }
      else
      {
        // Update features that have changed.
        updateFeatures(config);
      }
    }

    // Save new config.
    config_ = config;
  };

  /** Read and publish camera data. */
  void readAndPublish()
  {
    // @todo check for valid sensor size info in cam info message?
    left_cam_info_  = left_cam_mgr_->getCameraInfo();
    right_cam_info_ = right_cam_mgr_->getCameraInfo();

    try
    {
      // Read data from the camera.
      dev_->readData(left_image_, right_image_);

      // Set frame IDs in headers.
      left_cam_info_.header.frame_id =
          right_cam_info_.header.frame_id =
              left_image_.header.frame_id =
                  right_image_.header.frame_id = frame_id_;

      // Timestamps *must* be the same (stereo pipeline requires this).
      left_cam_info_.header.stamp =
          right_cam_info_.header.stamp =
              left_image_.header.stamp = right_image_.header.stamp;

      // Publish via image_transport.
      left_image_pub_.publish(left_image_, left_cam_info_);
      right_image_pub_.publish(right_image_, right_cam_info_);
    }
    catch(arm_honeybee::Exception& e)
    {
      ROS_WARN_STREAM("[" << camera_name_ << "] Exception reading data: "
		      << e.what());
      // @todo bail out?
    }
  };

  /** Driver main spin loop. */
  void spin()
  {
    dynamic_reconfigure::Server<arm_honeybee::honeybeeConfig> srv;
    dynamic_reconfigure::Server<arm_honeybee::honeybeeConfig>::CallbackType f =
      boost::bind(&HoneybeeNode::reconfig, this, _1, _2);
    srv.setCallback(f);

    // Install segfault handler.
    signal(SIGSEGV, &sigsegv_handler);

    while(ros::ok())
    {
      if(state_ != Driver::CLOSED)
      {
        readAndPublish();
      }

      ros::spinOnce();
    }

    closeCamera();
  };
};

// Globals
HoneybeeNode *g_hb;

/** Segfault signal handler. */
void sigsegv_handler(int sig)
{
  signal(SIGSEGV, SIG_DFL);
  ROS_ERROR("Segmentation fault, stopping camera driver.");

  if(g_hb)
  {
    g_hb->closeCamera();
  }

  ros::shutdown();
}

/** Main entry point. */
int main(int argc, char **argv)
{
  ros::init(argc, argv, "honeybee");

  g_hb = new HoneybeeNode();
  g_hb->spin();

  delete g_hb;
  return 0;
}

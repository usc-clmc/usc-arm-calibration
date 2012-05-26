/*
 *  dev_bumblebee2.cpp
 *
 *  Created on: Nov 4, 2010
 *      Author: Jonathan Kelly
 */
#include <stdint.h>

// ROS
#include <sensor_msgs/image_encodings.h>

#include <ros/console.h>

// Adapted from the ROS camera1394 driver.
#include "dev_bumblebee2.h"

using namespace arm_honeybee;

#define NUM_DMA_BUFFERS 8


/** Macro for throwing an exception with a message. */
#define CAM_EXCEPT(except, msg)					\
{								\
  char buf[100];						\
  snprintf(buf, 100, "[Bumblebee2::%s]: " msg, __FUNCTION__);	\
  throw except(buf);						\
}

/** Macro for throwing an exception with a message, passing args. */
#define CAM_EXCEPT_ARGS(except, msg, ...)				\
{									\
  char buf[100];							\
  snprintf(buf, 100, "[Bumblebee2::%s]: " msg, __FUNCTION__, __VA_ARGS__); \
  throw except(buf);							\
}


const char* Bumblebee2::bee_string = "Bumblebee2";

// Constructor
Bumblebee2::Bumblebee2() : 
  capture_buffer_(NULL), context_(NULL), camera_(NULL)
{}

// Destructor
Bumblebee2::~Bumblebee2()
{
  safeCleanup();
}

/** Query PGR-specific register for Bayer tile pattern.
 *
 *  The method sets the internal Bayer tile variable for the appropirate
 *  ROS-defined image encoding.
 */
dc1394error_t Bumblebee2::getBayerTile()
{
  uint32_t val;

  // Query register 0x1040: BAYER_TILE_MAPPING
  if(DC1394_SUCCESS !=
     dc1394_get_control_register(camera_, BAYER_TILE_MAPPING_REGISTER, &val))
  {    
    return DC1394_FAILURE;
  }

  // ASCII R = 52 G = 47 B = 42 Y = 59
  switch(val)
  {
  default:
  case 0x59595959:	// YYYY (no Bayer)
    // static_cast<dc1394color_filter_t>(0);
    bayer_tile_ = sensor_msgs::image_encodings::MONO8;
    break;
  case 0x52474742:
    // DC1394_COLOR_FILTER_RGGB;
    bayer_tile_ = sensor_msgs::image_encodings::BAYER_RGGB8;
    break;
  case 0x47425247:
    // DC1394_COLOR_FILTER_GBRG;
    bayer_tile_ = sensor_msgs::image_encodings::BAYER_GBRG8;
    break;
  case 0x47524247:
    // DC1394_COLOR_FILTER_GRBG;
    bayer_tile_ = sensor_msgs::image_encodings::BAYER_GRBG8;
    break;
  case 0x42474752:
    // DC1394_COLOR_FILTER_BGGR;
    bayer_tile_ = sensor_msgs::image_encodings::BAYER_BGGR8;
    break;
  }

  return DC1394_SUCCESS;
}

/** Query PGR-specific register for sensor information. */
dc1394error_t Bumblebee2::getSensorInfo()
{
  uint32_t val;

  // Query register 0x1F28: SENSOR_BOARD_INFO
  if(DC1394_SUCCESS !=
      dc1394_get_control_register(camera_, SENSOR_BOARD_INFO_REGISTER, &val))
  {
    return DC1394_FAILURE;
  }

  unsigned char sensor_info = 0xf & val;

  switch(sensor_info)
  {
  default:
    // Unknown sensor!
    ROS_ERROR("Illegal sensor board information detected!");
    return DC1394_FAILURE;
  case 0xA:	// color 640x480
     color_coding_ = DC1394_COLOR_CODING_RAW16;
     height_ = 480;
     width_  = 640;
     break;
   case 0xB:	// mono 640x480
     color_coding_ = DC1394_COLOR_CODING_MONO16;
     height_ = 480;
     width_  = 640;
     break;
   case 0xC:	// color 1024x768
     color_coding_ = DC1394_COLOR_CODING_RAW16;
     height_ = 768;
     width_  = 1024;
     break;
   case 0xD:	// mono 1024x768
     color_coding_ = DC1394_COLOR_CODING_MONO16;
     height_ = 768;
     width_  = 1024;
     break;
   case 0xE:	// color 1280x960
     color_coding_ = DC1394_COLOR_CODING_RAW16;
     height_ = 960;
     width_  = 1280;
     break;
   case 0xF:	// mono 1280x960
     color_coding_ = DC1394_COLOR_CODING_MONO16;
     height_ = 960;
     width_  = 1280;
     break;
   }

   return DC1394_SUCCESS;
}

/** Set PGR-specific endian format register.
 *
 *  @param big_endian Set to true for big-endian interlaced formatting
 *         (MSB is left image byte).
 */
dc1394error_t Bumblebee2::setEndian(bool big_endian)
{
  uint32_t val;

  if(big_endian)
  {
    // Use 16-bit modes in big endian (IEEE 1394 default) format.
    val = 0x80000001;
  }
  else
  {
    // Use 16-bit modes in little endian (PGR default) format.
    val = 0x80000000;
  }

  // Set register 0x1048: IMAGE_DATA_FORMAT_REGISTER
  return dc1394_set_control_register(camera_, IMAGE_DATA_FORMAT_REGISTER, val);
}

/** Find frame rate for Format 7 (as a float).
 *
 *  @return IEEE 1394-standard frame rate.
 */
float Bumblebee2::findFrameRateFormat7(float fps)
{
  if (fps < 3.75)
    return 1.875;
  else if (fps < 7.5)
    return 3.75;
  else if (fps < 15)
    return 7.5;
  else if (fps < 30)
    return 15;
  else if (fps < 60)
    return 30;
  else
    return 60;
}

/** Find IEEE 1394 isochroynous bus speed.
 *
 *  The function also sets the iso_speed argument to a valid value,
 *  when the supplied speed is unsupported.
 *
 *  @return DC1394 iso speed enum.
 */
dc1394speed_t Bumblebee2::findIsoSpeed(int& iso_speed)
{
  switch(iso_speed)
  {
  case 100:
    return DC1394_ISO_SPEED_100;
    break;
  case 200:
    return DC1394_ISO_SPEED_200;
    break;
  case 400:
    return DC1394_ISO_SPEED_400;
    break;
  case 800:
    return DC1394_ISO_SPEED_800;
    break;
  case 1600:
    return DC1394_ISO_SPEED_1600;
    break;
  case 3200:
    return DC1394_ISO_SPEED_3200;
    break;
  default:
    ROS_ERROR("Unsupported iso_speed. Defaulting to 400.");
    iso_speed = 400;
    return DC1394_ISO_SPEED_400;
    break;
  }
}

/** Verify that the camera is, in fact, a Bumblebee2.
 *
 *  @return true if the camera is a Bumblebee2.
 */
bool Bumblebee2::isBumblebee(dc1394camera_t* camera)
{
  if(strncmp(camera->model, bee_string, strlen(bee_string)) == 0)
    return true;

  return false;
}

/** Find Bumblebee camera with specific GUID.
 *
 *  @param list List of available cameras.
 *  @param guid Globally-unique camera ID.  Set to "NONE" to return any
 *         Bumblebee2 camera.
 *
 *  @return true if a Bumblebee2 with the specified GUID was found.
 */
bool Bumblebee2::findCameraWithGUID(dc1394camera_list_t* list, const char* guid)
{
  char* id = new char[1024];

  for(unsigned int i = 0; i < list->num; i++)
  {
    // Create a camera.
    camera_ = dc1394_camera_new(context_, list->ids[i].guid);

    if(!camera_) {
      ROS_WARN_STREAM("Failed to initialize camera with GUID "
		      << std::hex << list->ids[i].guid);
      continue;
    }

    uint32_t value[3];

    value[0]=  camera_->guid       & 0xffffffff;
    value[1]= (camera_->guid >>32) & 0x000000ff;
    value[2]= (camera_->guid >>40) & 0xfffff;

    sprintf(id,"%06x%02x%08x", value[2], value[1], value[0]);
    ROS_DEBUG("Comparing %s to %s", guid, id);

    if((strcmp(id, guid) == 0 || strcmp("NONE", guid) == 0) && 
       isBumblebee(camera_))
    {
      // Found the camera we were looking for.
      device_id_= id;
      break;
    }

    // Free camera only.
    dc1394_camera_free(camera_);
    camera_ = NULL;
  }

  delete[] id;

  if(!camera_)
  {
    ROS_ERROR("Failed to find Bumblebee2 camera with guid %s", guid);
    return false;
  }

  return true;
}

/** Determine Format 7 packet size for given iso speed and frame rate.
 *
 *  @param iso_speed  IIDC valid iso speed.
 *  @param fps        IIDC valid frame rate.
 *
 *  @return packet size in bytes.
 */
int Bumblebee2::findPacketSize(int iso_speed, float fps)
{
  float bus_period = 0.05/iso_speed;

  // Packets available per frame.
  uint32_t num_packets = static_cast<uint32_t>(1.0/(bus_period*fps) + 0.5);
  float packet_size =
      (2.0*width_*height_ + 8.0*num_packets - 1.0)/8.0/num_packets;

  uint32_t unit_bytes, max_bytes;

  dc1394_format7_get_packet_parameters(
    camera_, DC1394_VIDEO_MODE_FORMAT7_3, &unit_bytes, &max_bytes);

  uint32_t num_bytes = 
    (static_cast<uint32_t>(packet_size/unit_bytes + 1.0))*8*unit_bytes;

  return num_bytes < max_bytes ? num_bytes : max_bytes;
}

/** Open Bumblebee2 device.
 *
 *  @param guid      Globally unique ID for camera, or NONE for first available.
 *  @param fps       Frames per second (adjusted to standard IIDC frame rate).
 *  @param iso_speed Iso bus speed (100, 200, 400 or 800 currently).
 *  @param reset     Set to true to reset IEEE 1394 bus prior to startup.
 *
 *  @return 0 if the device is opened successfully, or nonzero on error.
 */
int Bumblebee2::open(const char* guid, float fps, int iso_speed, bool reset)
{
  dc1394camera_list_t* list; 
  context_ = dc1394_new();

  if(context_ == NULL)
  {
    CAM_EXCEPT(arm_honeybee::Exception, "Unable to initialize dc1394 context.");
  }
 
  if(DC1394_SUCCESS != dc1394_camera_enumerate(context_, &list))
  {
    safeCleanup();
    CAM_EXCEPT(arm_honeybee::Exception, "Unable to retrieve list of cameras.");
  }

  if(list->num == 0)
  {
    safeCleanup();
    CAM_EXCEPT(arm_honeybee::Exception, "No cameras found.");
  }

  // Locate the desired Bumblebee2 on the bus...
  findCameraWithGUID(list, guid);

  // Tidy up cameras list (no longer needed).
  dc1394_camera_free_list(list);
  
  if(!camera_ ||
     (strcmp(guid, "NONE") != 0 && strcmp(device_id_.c_str(), guid) != 0))
  {
    safeCleanup();
    CAM_EXCEPT(arm_honeybee::Exception,
	       "Failed to find a useable Bumblebee2 camera.");
  }

  // Reset the FireWire bus?
  if(reset)
  {
    if(DC1394_SUCCESS != dc1394_reset_bus(camera_))
    {
      ROS_WARN("Failed to successfully reset the FireWire bus.");
    }
  }

  // Reset camera first...
  if(DC1394_SUCCESS != dc1394_camera_reset(camera_))
  {
    safeCleanup();
    CAM_EXCEPT(arm_honeybee::Exception, "Unable to reset camera.");
  }

  // Load camera factory defaults - auto-everything.  
  if(DC1394_SUCCESS != dc1394_memory_load(camera_, 0 ))
  {
    safeCleanup();
    CAM_EXCEPT(arm_honeybee::Exception,
	       "Unable to load default settings on camera.");
  }

  // Set 16-bit transmission to be PGR-default little endian.
  if(DC1394_SUCCESS != setEndian(false))
  {
    safeCleanup();
    CAM_EXCEPT(arm_honeybee::Exception,
        "Can't set Bumblebee2 into little-endian mode.");
  }

  // Get sensor information (width, height, color/mono).
  if(DC1394_SUCCESS != getSensorInfo())
  {
    safeCleanup();
    CAM_EXCEPT(arm_honeybee::Exception,
        "Unable to retrieve sensor information.");
  }

  // Find frame rate and iso speed.
  float frame_rate = findFrameRateFormat7(fps);
  dc1394speed_t speed = findIsoSpeed(iso_speed);

  // Initialized capture buffer (required for interlaced image decoding).
  capture_buffer_ = new unsigned char[width_*height_*2];

  // Set parameters that are common between Format 7 and other modes.
  if(DC1394_SUCCESS != dc1394_video_set_iso_speed(camera_, speed))
  {
    ROS_WARN("Unable to set camera iso speed.");
  }
  else
  {
    iso_speed_ = speed;
  }

  // Bumblebee2 transmits stereo images in Format 7, Mode 3.
  if(DC1394_SUCCESS !=
     dc1394_video_set_mode(camera_, DC1394_VIDEO_MODE_FORMAT7_3))
  {
    // Fatal...
    safeCleanup();
    CAM_EXCEPT(arm_honeybee::Exception, "Unable to set Format 7 video mode.");
  }
  
  // Setting the frame rate is more complicated for Format 7 modes.
  // @todo: verify iso speed is valid?
  ROS_DEBUG_STREAM("Requested iso speed is :"  << iso_speed);
  ROS_DEBUG_STREAM("Requested frame rate is:" << frame_rate);
  ROS_DEBUG_STREAM("Camera image size is   : " << width_ << " x " << height_);

  int bytes = findPacketSize(iso_speed, fps);

  if(DC1394_SUCCESS != 
     dc1394_format7_set_roi(camera_, DC1394_VIDEO_MODE_FORMAT7_3, 
      static_cast<dc1394color_coding_t>(DC1394_QUERY_FROM_CAMERA),
      bytes, 0, 0, width_, height_))
  {
    // Fatal...
    safeCleanup();
    CAM_EXCEPT(arm_honeybee::Exception, "Unable to set Format 7 ROI.");
  }

  // Get Bayer information directly from the camera.
  // Note: This has to be done *after* setting the video mode -
  // otherwise, the Bayer register may contain the wrong value.
  if(DC1394_SUCCESS != getBayerTile())
  {
    safeCleanup();
    CAM_EXCEPT(arm_honeybee::Exception,
        "Unable to retrieve Bayer pattern information.");
  }

  // Setup for capture...
  if(DC1394_SUCCESS != dc1394_capture_setup(camera_,
      NUM_DMA_BUFFERS,
      DC1394_CAPTURE_FLAGS_DEFAULT))
  {
    safeCleanup();
    CAM_EXCEPT(arm_honeybee::Exception, "Failed to setup Bumblebee2 capture.");
   }

  // Start transmitting camera data...
  if(DC1394_SUCCESS != dc1394_video_set_transmission(camera_, DC1394_ON))
  {
    safeCleanup();
    CAM_EXCEPT(arm_honeybee::Exception, "Failed to start Bumblebee2 capture.");
   }
  
  // Verify successful transmission start.
  dc1394switch_t status = DC1394_OFF;

  for(int i = 0;; i++)
  {
    usleep(50000);

    if(DC1394_SUCCESS != dc1394_video_get_transmission(camera_, &status))
    {
      safeCleanup();
      CAM_EXCEPT(arm_honeybee::Exception, 
          "Unable to get Bumblebee2 iso transmision status." );
    }
 
    if(status != DC1394_OFF)
      break;  // Good to go...

    if(i == 5)
    {
      safeCleanup();
      CAM_EXCEPT(arm_honeybee::Exception, "Bumblebee2 won't turn on?");
    }
  }

  return 0;
}

/** Safe cleanup - shutdown gracefully. */
void Bumblebee2::safeCleanup()
{
  if(camera_)
  {
    dc1394_capture_stop(camera_);
    dc1394_camera_free(camera_);
    camera_ = NULL;
  }

  if(context_)
  {
    dc1394_free(context_);
    context_ = NULL;
  }

  if(capture_buffer_)
  {
    delete[] capture_buffer_;
    capture_buffer_ = NULL;
  }
}

/** Set auto exposure.
 *
 *  Auto exposure is more complicated than other settings.  See Section
 *  2.10.2 of the Point Grey Digital Camera Register Reference for more
 *  information.
 *
 *  If one or more of the shutter and gain values are set to auto, then
 *  setting the auto exposure value has an effect.
 *
 *  Using a value less than 0 will produce a 'visually pleasing' image
 *  (fully automatic exposure control). Otherwise, gain and/or shutter
 *  will be adjusted to try to match the average image intensity to the
 *  value supplied.
 *
 *  @param[in,out] exposure Exposure value, less than 0 for automatic
 *                 exposure control.
 */
int Bumblebee2::setAutoExposure(int& exposure)
{
  bool auto_exposure = exposure < 0;

  if(DC1394_SUCCESS !=
     dc1394_feature_set_mode(camera_, DC1394_FEATURE_EXPOSURE,
     (auto_exposure ? DC1394_FEATURE_MODE_AUTO: DC1394_FEATURE_MODE_MANUAL)))
  {
    ROS_ERROR("Unable to set auto exposure mode.");
    return -1;
  }

  if(!auto_exposure)
  {
    // Clamp to valid range.
    uint32_t min, max;

    if(DC1394_SUCCESS ==
        dc1394_feature_get_boundaries(
            camera_, DC1394_FEATURE_EXPOSURE, &min, &max))
    {
      // DEBUG
      ROS_DEBUG("Exposure (min, max, now): %d, %d, %d", min, max, exposure);

      if(exposure < static_cast<int>(min))
        exposure = min;
      else if(exposure > static_cast<int>(max))
        exposure = max;
    }

    if(DC1394_SUCCESS !=
        dc1394_feature_set_value(camera_, DC1394_FEATURE_EXPOSURE, exposure))
    {
      ROS_ERROR("Unable to set auto exposure value.");
      return -1;
    }
  }

  return 0;
}

/** Set brightness.
 *
 *  @param[in,out] brightness Brightness value, less than 0 for automatic
 *                 brightness control.
 */
int Bumblebee2::setBrightness(int& brightness)
{
  bool auto_brightness = brightness < 0;

  if(DC1394_SUCCESS !=
     dc1394_feature_set_mode(camera_, DC1394_FEATURE_BRIGHTNESS,
     (auto_brightness ? DC1394_FEATURE_MODE_AUTO: DC1394_FEATURE_MODE_MANUAL)))
  {
    ROS_ERROR("Unable to set brightness mode.");
    return -1;
  }

  if(!auto_brightness)
  {
    // Clamp to valid range.
    uint32_t min, max;

    if(DC1394_SUCCESS ==
        dc1394_feature_get_boundaries(
            camera_, DC1394_FEATURE_BRIGHTNESS, &min, &max))
    {
      if(brightness < static_cast<int>(min))
        brightness = min;
      else if(brightness > static_cast<int>(max))
        brightness = max;
    } 

    if(DC1394_SUCCESS !=
      dc1394_feature_set_value(camera_, DC1394_FEATURE_BRIGHTNESS, brightness))
    {
      ROS_ERROR("Unable to set brightness value.");
      return -1;
    }
  }

  return 0;
}

/** Set (absolute) brightness.
 *
 *  @param[in,out] brightness Brightness value, less than 0 for automatic
 *                 brightness control.
 */
int Bumblebee2::setBrightnessAbs(float& brightness)
{
  bool auto_brightness = brightness < 0;

  if(DC1394_SUCCESS !=
     dc1394_feature_set_mode(camera_, DC1394_FEATURE_BRIGHTNESS,
     (auto_brightness ? DC1394_FEATURE_MODE_AUTO: DC1394_FEATURE_MODE_MANUAL)))
  {
    ROS_ERROR("Unable to set brightness mode.");
    return -1;
  }

  if(!auto_brightness)
  {
    // Set absolute control mode.
    if(DC1394_SUCCESS !=
        dc1394_feature_set_absolute_control(
            camera_, DC1394_FEATURE_BRIGHTNESS, DC1394_ON))
    {
      ROS_ERROR("Unable to set abs. brightness control.");
      return -1;
    }

    // Clamp to valid range.
    float min, max;

    if(DC1394_SUCCESS ==
       dc1394_feature_get_absolute_boundaries(
           camera_, DC1394_FEATURE_BRIGHTNESS, &min, &max))
    {
      // DEBUG
      ROS_DEBUG(
          "Abs. brightness (min, max, now): %.3f, %.3f, %.3f",
          min, max, brightness);

      if(brightness < min)
      {
        ROS_DEBUG("Abs. brightness clamped to minimum.");
        brightness = min;
      }
      else if(brightness > max)
      {
        ROS_DEBUG("Abs. brightness clamped to maximum.");
        brightness = max;
      }
    }

    if(DC1394_SUCCESS !=
        dc1394_feature_set_absolute_value(
            camera_, DC1394_FEATURE_BRIGHTNESS, brightness))
    {
      ROS_ERROR("Unable to set abs. brightness.");
      return -1;
    }
  }

  return 0;
}

/** Set gain.
 *
 *  @param[in,out] gain Gain value, less than 0 for auto gain control.
 */
int Bumblebee2::setGain(int& gain)
{
  bool auto_gain = gain < 0;

  if(DC1394_SUCCESS !=
     dc1394_feature_set_mode(camera_, DC1394_FEATURE_GAIN,
     (auto_gain ? DC1394_FEATURE_MODE_AUTO: DC1394_FEATURE_MODE_MANUAL)))
  {
    ROS_ERROR("Unable to set gain mode.");
    return -1;
  }

  if(!auto_gain)
  {
    // Clamp to valid range.
    uint32_t min, max;

    if(DC1394_SUCCESS ==
        dc1394_feature_get_boundaries(camera_, DC1394_FEATURE_GAIN, &min, &max))
    {
      if(gain < static_cast<int>(min))
        gain = min;
      else if(gain > static_cast<int>(max))
        gain = max;
    } 

    if(DC1394_SUCCESS !=
        dc1394_feature_set_value(camera_, DC1394_FEATURE_GAIN, gain))
    {
      ROS_ERROR("Unable to set gain.");
      return -1;
    }
  }

  return 0;
}

/** Set (absolute) gain.
 *
 *  @param[in,out] gain Gain value in dB, less than 0 for automatic
 *                 gain control.
 */
int Bumblebee2::setGainAbs(float& gain)
{
  bool auto_gain = gain < 0;

  if(DC1394_SUCCESS !=
     dc1394_feature_set_mode(camera_, DC1394_FEATURE_GAIN,
     (auto_gain ? DC1394_FEATURE_MODE_AUTO: DC1394_FEATURE_MODE_MANUAL)))
  {
    ROS_ERROR("Unable to set gain mode.");
    return -1;
  }

  if(!auto_gain)
  {
    // Set absolute control mode.
    if(DC1394_SUCCESS !=
        dc1394_feature_set_absolute_control(
            camera_, DC1394_FEATURE_GAIN, DC1394_ON))
    {
      ROS_ERROR("Unable to set abs. gain control.");
      return -1;
    }

    // Clamp to valid range.
    float min, max;

    if(DC1394_SUCCESS ==
        dc1394_feature_get_absolute_boundaries(
            camera_, DC1394_FEATURE_GAIN, &min, &max))
    {
      // DEBUG
      ROS_DEBUG("Abs. gain (min, max, now): %.3f, %.3f, %.3f", min, max, gain);

      if(gain < min)
      {
        ROS_DEBUG("Abs. gain clamped to minimum.");
        gain = min;
      }
      else if(gain > max)
      {
        ROS_DEBUG("Abs. gain clamped to maximum.");
        gain = max;
      }
    }

    if(DC1394_SUCCESS !=
       dc1394_feature_set_absolute_value(camera_, DC1394_FEATURE_GAIN, gain))
    {
      ROS_ERROR("Unable to set abs. gain.");
      return -1;
    }
  }

  return 0;
}

/** Set shutter speed.
 *
 *  @param[in,out] shutter Shutter speed, less than 0 for automatic
 *                 shutter control.
 */
int Bumblebee2::setShutter(int& shutter)
{
  bool auto_shutter = shutter < 0;

  if(DC1394_SUCCESS !=
     dc1394_feature_set_mode(camera_, DC1394_FEATURE_SHUTTER,
     (auto_shutter ? DC1394_FEATURE_MODE_AUTO: DC1394_FEATURE_MODE_MANUAL)))
  {
    ROS_ERROR("Unable to set shutter mode.");
    return -1;
  }

  if(!auto_shutter)
  {
    // Clamp to valid range.
    uint32_t min, max;

    if(DC1394_SUCCESS ==
        dc1394_feature_get_boundaries(
            camera_, DC1394_FEATURE_SHUTTER, &min, &max))
    {
      if(shutter < static_cast<int>(min))
        shutter = min;
      else if(shutter > static_cast<int>(max))
        shutter = max;
    }

    if(DC1394_SUCCESS !=
       dc1394_feature_set_value(camera_, DC1394_FEATURE_SHUTTER, shutter))
    {
      ROS_ERROR("Unable to set shutter value.");
      return -1;
    }
  }

  return 0;
}

/** Set (absolute) shutter.
 *
 *  @param[in,out] shutter Shutter speed in seconds, less than 0 for automatic
 *                 shutter control.
 */
int Bumblebee2::setShutterAbs(float& shutter)
{
  bool auto_shutter = shutter < 0;

  if(DC1394_SUCCESS !=
      dc1394_feature_set_mode(camera_, DC1394_FEATURE_SHUTTER,
      (auto_shutter ? DC1394_FEATURE_MODE_AUTO: DC1394_FEATURE_MODE_MANUAL)))
  {
    ROS_ERROR("Unable to set shutter mode.");
    return -1;
  }

  if(!auto_shutter)
  {
    // Set absolute control mode.
    if(DC1394_SUCCESS !=
       dc1394_feature_set_absolute_control(
           camera_, DC1394_FEATURE_SHUTTER, DC1394_ON))
    {
      ROS_ERROR("Unable to set abs. shutter control.");
      return -1;
    }

    // Clamp to valid range.
    float min, max;

    if(DC1394_SUCCESS ==
       dc1394_feature_get_absolute_boundaries(
           camera_, DC1394_FEATURE_SHUTTER, &min, &max))
    {
      // DEBUG
      ROS_DEBUG(
          "Abs. shutter (min, max, now): %.3f, %.3f, %.3f", min, max, shutter);

      if(shutter < min)
      {
        ROS_DEBUG("Abs. shutter clamped to minimum.");
        shutter = min;
      }
      else if(shutter > max)
      {
        ROS_DEBUG("Abs. shutter clamped to maximum.");
        shutter = max;
      }
    }

    if(DC1394_SUCCESS !=
       dc1394_feature_set_absolute_value(
           camera_, DC1394_FEATURE_SHUTTER, shutter))
    {
      ROS_ERROR("Unable to set abs. shutter.");
      return -1;
    }
  }

  return 0;
}

/** Set white balance.
 *
 *  @param whitebalance White balance, or "auto" for automatic white balance.
 */
int Bumblebee2::setWhiteBalance(const char* whitebalance)
{
  bool set_white_balance = false;
  bool auto_white_balance = false;
  unsigned int blue_balance, red_balance;

  if(strcmp(whitebalance, "auto") == 0)
  {
    set_white_balance  = true;
    auto_white_balance = true;
  }
  else
  {
    auto_white_balance = false;

    if(sscanf(whitebalance,"%u %u", &blue_balance, &red_balance) == 2)
      set_white_balance = true;
    else
      ROS_ERROR("Didn't understand white balance values [%s].", whitebalance);
  }

  if(set_white_balance)
  {
    // DEBUG
    if(auto_white_balance)
    {
      ROS_INFO("Setting auto white balance.");
    }
    else
    {
      ROS_INFO("Setting white balance to %d, %d.", blue_balance, red_balance);
    }

    if(DC1394_SUCCESS !=
        dc1394_feature_set_mode(camera_, DC1394_FEATURE_WHITE_BALANCE,
            (auto_white_balance ?
                DC1394_FEATURE_MODE_AUTO : DC1394_FEATURE_MODE_MANUAL)))
    {
      ROS_ERROR("Unable to set white balance mode.");
      return -1;
    }

    if(!auto_white_balance)
      if(DC1394_SUCCESS !=
          dc1394_feature_whitebalance_set_value(camera_,
              blue_balance,
              red_balance))
    {
      ROS_ERROR("Unable to set white balance.");
      return -1;
    }
  }

  return 0;
}

/** Close Bumblebee2 device. */
int Bumblebee2::close()
{
  if(camera_)
  {
    if(DC1394_SUCCESS != dc1394_video_set_transmission(camera_, DC1394_OFF) ||
       DC1394_SUCCESS != dc1394_capture_stop(camera_))
      ROS_WARN("Unable to stop camera.");
  }

  safeCleanup();
  return 0;
}

/** Return left and right image frames */
void Bumblebee2::readData(sensor_msgs::Image& image_l,
                          sensor_msgs::Image& image_r)
{
  if(camera_ == NULL)
  {
    safeCleanup();
    CAM_EXCEPT(arm_honeybee::Exception, "Read attempted on NULL camera port.");
  }

  dc1394video_frame_t* frame = NULL;
  dc1394_capture_dequeue(camera_, DC1394_CAPTURE_POLICY_WAIT, &frame);
  
  if(!frame)
  {
    safeCleanup();
    CAM_EXCEPT(arm_honeybee::Exception, "Unable to dequeue stereo frame.");
  }

  int image_size = width_*height_;
  
  image_l.width  = image_r.width  = width_;
  image_l.height = image_r.height = height_; 
  image_l.step   = image_r.step   = width_;

  // Set encoding based on Bayer pattern.
  image_l.encoding = image_r.encoding = bayer_tile_;

  // Both images have the same timestamp.
  image_l.header.stamp = image_r.header.stamp = 
    ros::Time(frame->timestamp*1.e-6);

  // ROS_INFO("time offset between cam and ros %f",
  //     (ros::Time::now() - image_l.header.stamp).toSec());

  image_l.data.resize(image_size);
  image_r.data.resize(image_size);

  // Frame buffer stores 16-bit mono data: MSB - right, LSB - left,
  // for Point Grey default little-endian setting.
  if(DC1394_SUCCESS != 
     dc1394_deinterlace_stereo(
       static_cast<unsigned char *>(frame->image),
       static_cast<unsigned char *>(capture_buffer_),
       width_, height_*2))
  {
    safeCleanup();
    CAM_EXCEPT(arm_honeybee::Exception, "Unable to deinterlace stereo image.");
  }

  memcpy(&image_l.data[0], &capture_buffer_[image_size], image_size);
  memcpy(&image_r.data[0], &capture_buffer_[0], image_size);

  // Release frame back to ring buffer.
  dc1394_capture_enqueue(camera_, frame);
}

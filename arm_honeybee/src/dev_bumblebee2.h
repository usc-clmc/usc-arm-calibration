/*
 *  dev_bumblebee2.h
 *
 *  Created on: Nov 4, 2010
 *      Author: Jonathan Kelly
 */
#ifndef __DEV_BUMBLEBEE2_H__
#define __DEV_BUMBLEBEE2_H__

#include <dc1394/dc1394.h>

// ROS
#include <sensor_msgs/Image.h>

namespace arm_honeybee
{
  // PGR-specific registers on the Bumblebee2.
  #define BAYER_TILE_MAPPING_REGISTER   (0x1040)
  #define SENSOR_BOARD_INFO_REGISTER    (0x1f28)
  #define IMAGE_DATA_FORMAT_REGISTER	(0x1048)

  /** Macro for defining an exception with a given parent.
   *  (std::runtime_error should be top parent)
   */
  #define DEF_EXCEPTION(name, parent)		\
    class name  : public parent {			\
    public:					\
      name (const char* msg) : parent (msg) {}	\
    }

  /** A standard Honeybee exception. */
  DEF_EXCEPTION(Exception, std::runtime_error);

  class Bumblebee2
  {
  public:
    Bumblebee2();
    ~Bumblebee2();

    int  open(const char* guid, float fps, int iso_speed, bool reset);
    int  close();

    void readData(sensor_msgs::Image &image_l, sensor_msgs::Image &image_r);

    int setAutoExposure(int& exposure);

    int setBrightness(int& brightness);
    int setBrightnessAbs(float& brightness);

    int setGain(int& gain);
    int setGainAbs(float& gain);

    int setShutter(int& shutter);
    int setShutterAbs(float& shutter);

    int setWhiteBalance(const char* whitebalance);

    std::string device_id_;

  private:
    static const char*   bee_string;

    unsigned int         width_;
    unsigned int         height_;
    unsigned char*       capture_buffer_;

    dc1394_t*            context_;
    dc1394camera_t*      camera_;

    dc1394framerate_t    frame_rate_;
    dc1394speed_t        iso_speed_;
 
    dc1394color_coding_t color_coding_;
    std::string          bayer_tile_;

    bool isBumblebee(dc1394camera_t* camera);
    bool findCameraWithGUID(dc1394camera_list_t* list, const char* guid);
    void safeCleanup();

    dc1394speed_t findIsoSpeed(int& iso_speed);
    float         findFrameRateFormat7(float fps);
    int           findPacketSize(int iso_speed, float fps);

    // Low-level register access routines.
    dc1394error_t getBayerTile();
    dc1394error_t getSensorInfo();
    dc1394error_t setEndian(bool big_endian);
  };
};

#endif

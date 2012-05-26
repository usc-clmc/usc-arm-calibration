/*********************************************************************
  Computational Learning and Motor Control Lab
  University of Southern California
  Prof. Stefan Schaal 
 *********************************************************************
  \remarks		...
 
  \file		dashboard_client.h

  \author	Peter Pastor
  \date		Aug 19, 2011

 *********************************************************************/

#ifndef DASHBOARD_CLIENT_H_
#define DASHBOARD_CLIENT_H_

// system includes
#include <ros/ros.h>
#include <vector>
#include <string>
#include <SafetyLight_msgs/SetColor.h>

// local includes

namespace arm_dashboard_client
{

class DashboardClient
{

public:

  DashboardClient();
  virtual ~DashboardClient() {};

  /*! Appends the provided string to the usc dashboard as DEBUG
   * @param status_string
   */
  void debug(const std::string status_string = "");

  /*! Appends the provided string to the usc dashboard as DEBUG
   * @param format accepts formatting similar to printf
   */
  void debug(const char* format, ...);

  /*! Appends the provided string to the usc dashboard as INFO
   * @param status_string
   */
  void info(const std::string status_string = "");

  /*! Appends the provided string to the usc dashboard as INFO
   * @param format accepts formatting similar to printf
   */
  void info(const char* format, ...);

  /*! Appends the provided string to the usc dashboard as WARNING
   * @param status_string
   */
  void warn(const std::string status_string = "");

  /*! Appends the provided string to the usc dashboard as WARNING
   * @param format accepts formatting similar to printf
   */
  void warn(const char* format, ...);

  /*! Appends the provided string to the usc dashboard as ERROR
   * @param status_string
   */
  void error(const std::string status_string = "");

  /*! Appends the provided string to the usc dashboard as ERROR
   * @param format accepts formatting similar to printf
   */
  void error(const char* format, ...);

  /*! Appends the provided string to the usc dashboard as FATAL
   * @param status_string
   */
  void fatal(const std::string status_string = "");

  /*! Appends the provided string to the usc dashboard as FATAL
   * @param format accepts formatting similar to printf
   */
  void fatal(const char* format, ...);

  /*!
   * @return True if subscribers are present
   */
  bool isConnectedToSafetyLights();
  bool isConnectedToDashboard();

private:

  ros::NodeHandle node_handle_;
  ros::Publisher status_report_publisher_;
  ros::Publisher safety_lights_publisher_;
  void send(const std::string& status_string, const int mode);
  std::vector<SafetyLight_msgs::SetColor> colors_;

};

}

#endif /* DASHBOARD_CLIENT_H_ */

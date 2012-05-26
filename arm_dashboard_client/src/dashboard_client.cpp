/*********************************************************************
  Computational Learning and Motor Control Lab
  University of Southern California
  Prof. Stefan Schaal 
 *********************************************************************
  \remarks		...
 
  \file		dashboard_client.cpp

  \author	Peter Pastor
  \date		Aug 19, 2011

 *********************************************************************/

// system includes
#include <stdarg.h>

#include <arm_msgs/StatusReport.h>

// local includes
#include <arm_dashboard_client/dashboard_client.h>

namespace arm_dashboard_client
{

const int MAX_LENGTH = 256;

DashboardClient::DashboardClient() :
  node_handle_(ros::NodeHandle("/USCDashboard"))
{
  status_report_publisher_ = node_handle_.advertise<arm_msgs::StatusReport>("status_string", 10);
  safety_lights_publisher_ = node_handle_.advertise<SafetyLight_msgs::SetColor>("/SafetyLight/set_color", 10);

  SafetyLight_msgs::SetColor debug_color;
  debug_color.r = 204;
  debug_color.g = 204;
  debug_color.b = 204;
  colors_.push_back(debug_color);

  SafetyLight_msgs::SetColor info_color;
  info_color.r = 0;
  info_color.g = 255;
  info_color.b = 0;
  colors_.push_back(info_color);

  SafetyLight_msgs::SetColor warn_color;
  warn_color.r = 255;
  warn_color.g = 125;
  warn_color.b = 0;
  colors_.push_back(warn_color);

  SafetyLight_msgs::SetColor error_color;
  error_color.r = 255;
  error_color.g = 0;
  error_color.b = 0;
  colors_.push_back(error_color);

  SafetyLight_msgs::SetColor fatal_color;
  fatal_color.r = 255;
  fatal_color.g = 0;
  fatal_color.b = 224;
  colors_.push_back(fatal_color);
}

bool DashboardClient::isConnectedToSafetyLights()
{
  return (safety_lights_publisher_.getNumSubscribers() > 0);
}
bool DashboardClient::isConnectedToDashboard()
{
  return (status_report_publisher_.getNumSubscribers() > 0);
}

void DashboardClient::send(const std::string& status_string, const int mode)
{
  if(!status_string.empty())
  {
    arm_msgs::StatusReport status_report;
    status_report.mode = mode;
    status_report.status.assign(status_string);
    status_report_publisher_.publish(status_report);
    ROS_DEBUG_STREAM_COND(mode==arm_msgs::StatusReport::DEBUG, status_string);
    ROS_INFO_STREAM_COND(mode==arm_msgs::StatusReport::INFO, status_string);
    ROS_WARN_STREAM_COND(mode==arm_msgs::StatusReport::WARN, status_string);
    ROS_ERROR_STREAM_COND(mode==arm_msgs::StatusReport::ERROR, status_string);
    ROS_FATAL_STREAM_COND(mode==arm_msgs::StatusReport::FATAL, status_string);
  }
  SafetyLight_msgs::SetColor color = colors_[mode];
  safety_lights_publisher_.publish(color);
}

void DashboardClient::debug(const std::string status_string)
{
  send(status_string, arm_msgs::StatusReport::DEBUG);
}

void DashboardClient::debug(const char* format, ...)
{
  char buffer[MAX_LENGTH];
  va_list args;
  va_start (args, format);
  int len = vsnprintf(buffer, MAX_LENGTH - 1, format, args);
  va_end (args);
  if (len < 0)
  {
    error("Invalid INFO print requested. Ignoring...");
    return;
  }
  debug(std::string(buffer));
}

void DashboardClient::info(const std::string status_string)
{
  send(status_string, arm_msgs::StatusReport::INFO);
}

void DashboardClient::info(const char* format, ...)
{
  char buffer[MAX_LENGTH];
  va_list args;
  va_start (args, format);
  int len = vsnprintf(buffer, MAX_LENGTH - 1, format, args);
  va_end (args);
  if (len < 0)
  {
    error("Invalid INFO print requested. Ignoring...");
    return;
  }
  info(std::string(buffer));
}

void DashboardClient::warn(const std::string status_string)
{
  send(status_string, arm_msgs::StatusReport::WARN);
}

void DashboardClient::warn(const char* format, ...)
{
  char buffer[MAX_LENGTH];
  va_list args;
  va_start (args, format);
  int len = vsnprintf(buffer, MAX_LENGTH - 1, format, args);
  va_end (args);
  if (len < 0)
  {
    error("Invalid WARN print requested. Ignoring...");
    return;
  }
  warn(std::string(buffer));
}

void DashboardClient::error(const std::string status_string)
{
  send(status_string, arm_msgs::StatusReport::ERROR);
}

void DashboardClient::error(const char* format, ...)
{
  char buffer[MAX_LENGTH];
  va_list args;
  va_start (args, format);
  int len = vsnprintf(buffer, MAX_LENGTH - 1, format, args);
  va_end (args);
  if (len < 0)
  {
    error("Invalid ERROR print requested. Ignoring...");
    return;
  }
  error(std::string(buffer));
}

void DashboardClient::fatal(const std::string status_string)
{
  send(status_string, arm_msgs::StatusReport::FATAL);
}

void DashboardClient::fatal(const char* format, ...)
{
  char buffer[MAX_LENGTH];
  va_list args;
  va_start (args, format);
  int len = vsnprintf(buffer, MAX_LENGTH - 1, format, args);
  va_end (args);
  if (len < 0)
  {
    error("Invalid FATAL print requested. Ignoring...");
    return;
  }
  fatal(std::string(buffer));
}

}

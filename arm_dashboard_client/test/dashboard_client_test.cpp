/*********************************************************************
  Computational Learning and Motor Control Lab
  University of Southern California
  Prof. Stefan Schaal 
 *********************************************************************
  \remarks		...
 
  \file		dashboard_client_test.cpp

  \author	Peter Pastor
  \date		Aug 19, 2011

 *********************************************************************/

// system includes
#include <ros/ros.h>
// local includes
#include <arm_dashboard_client/dashboard_client.h>

int main(int argc, char** argv)
{
  ros::init(argc, argv, "TestDashboardClient");
  ros::NodeHandle node_handle("~");

  std::string test_string = "test_string";
  int test_int = 1;
  double test_double = 0.721234;

  arm_dashboard_client::DashboardClient dashboard_client;
  while (ros::ok())
  {
    dashboard_client.debug("Debugging message.");
    dashboard_client.debug("Debugging message >%s< >%i< >%.2f<.", test_string.c_str(), test_int, test_double);

    dashboard_client.info("Info message.");
    dashboard_client.info("Info message >%s< >%i< >%.2f<.", test_string.c_str(), test_int, test_double);

    dashboard_client.warn("Warning message.");
    dashboard_client.warn("Warning message >%s< >%i< >%.2f<.", test_string.c_str(), test_int, test_double);

    dashboard_client.error("Error message.");
    dashboard_client.error("Error message >%s< >%i< >%.2f<.", test_string.c_str(), test_int, test_double);

    dashboard_client.fatal("Fatal message.");
    dashboard_client.fatal("Fatal message >%s< >%i< >%.2f<.", test_string.c_str(), test_int, test_double);

    // dashboard_client.info("Next 2 messages print crap...");
    // dashboard_client.debug("Fatal message >%s<.", test_string.c_str(), test_int, test_double);

    // WARNING: this segfaults your code.
    // Cannot print string as float. Unfortunatelly there is no warning during compilation
    // TODO: fix this
    // dashboard_client.info("Info message >%s< >%s< >%.2f<.", test_string.c_str(), test_int, test_double);
    // dashboard_client.warn("Warning message >%f< >%i< >%.2f<.", test_string.c_str(), test_int, test_double);
    // dashboard_client.error("Error message >%s< >%i< >%.2s<.", test_string.c_str(), test_int, test_double);
    // dashboard_client.fatal("Fatal message >%s< >%i< >%i< >%.2f<.", test_string.c_str(), test_int, test_double);

    ros::spinOnce();
    ros::Duration(1.0).sleep();
  }
  return 0;
}

#include <iostream>
#include <boost/python.hpp>
using namespace boost::python;

#include <ros/ros.h>
#include <tf/tf.h>
#include <tf/transform_listener.h>
#include <tf/tfMessage.h>
#include <tf/transform_datatypes.h>
#include <sensor_msgs/PointCloud.h>
#include <std_msgs/String.h>

/* This code mostly borrowed from the subscription_callback function
 * in transform_listener.cpp.
 *
 */
bool add_transform_to_transformer(
  char *msg_buf, tf::Transformer &transformer)
{
  bool r;
  tf::tfMessage msg_in;
  ros::serialization::IStream stream((uint8_t *)msg_buf, 1000000000);
  ros::serialization::deserialize(stream, msg_in.transforms);
  for (unsigned int i = 0; i < msg_in.transforms.size(); i++)
  {
    tf::StampedTransform trans;
    tf::transformStampedMsgToTF(msg_in.transforms[i], trans);
    r = transformer.setTransform(trans);
    if(!r)
      return r;
  }
  return true;
}

/* thin wrapper to make it easier to wrap this overloaded member function */
bool transformer_canTransform(
  tf::Transformer &transformer,
  const std::string& target_frame,
  const std::string& source_frame,
  const double t)
{
  ros::Time ros_time(t);
  return transformer.canTransform(target_frame, source_frame, ros_time);
}

/* thin wrapper to make it easier to wrap this overloaded member function */
bool transformer_waitForTransform(
  tf::Transformer &transformer,
  const std::string& target_frame,
  const std::string& source_frame,
  const ros::Time& time,
  const ros::Duration& timeout,
  const ros::Duration& polling_sleep_duration)
{
  return transformer.waitForTransform(
    target_frame, source_frame,
    time, timeout, polling_sleep_duration);
}

void deserialize_pointcloud_msg(char *buf)
{
  sensor_msgs::PointCloud pc_msg;
  ros::serialization::IStream stream((uint8_t *)buf, 1000000000);
  ros::serialization::deserialize(stream, pc_msg.header);
  ros::serialization::deserialize(stream, pc_msg.points);
  ros::serialization::deserialize(stream, pc_msg.channels);
  std::cout << "Deserialized " << pc_msg.points.size() << " points\n";
}

BOOST_PYTHON_MODULE(pier_ext)
{
  class_<tf::Transformer, boost::noncopyable>(
    "Transformer", init<bool, ros::Duration>());

  /*
  class_<std_msgs::String, boost::noncopyable>("String", init<>())
    .def_readwrite("data", &std_msgs::String::data);
  */

  class_<ros::Duration, boost::noncopyable>("Duration", init<double>());
  class_<ros::Time, boost::noncopyable>("Time", init<double>());
  /*
  class_<ros::Publisher, boost::noncopyable>("Publisher", no_init)
  .def("publish", &ros::Publisher::publish); */
  class_<ros::NodeHandle, boost::noncopyable>("NodeHandle", init<>())
    .def("advertise_string", &ros::NodeHandle::advertise<std_msgs::String>);

  /*
  def("transformer_canTransform", transformer_canTransform);
  def("transformer_waitForTransform", transformer_waitForTransform);
  def("add_transform_to_transformer", add_transform_to_transformer);
  def("deserialize_pointcloud_msg", deserialize_pointcloud_msg);
  */
}

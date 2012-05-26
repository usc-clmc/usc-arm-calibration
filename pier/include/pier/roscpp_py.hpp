#include <string>

#include <Python.h>
#include <numpy/arrayobject.h>
#include <boost/python.hpp>

#include <ros/ros.h>
#include <tf/transform_listener.h>

using namespace boost::python;

namespace pier
{
  template <class ReqT, class ResT>
  class ServiceHelper
  {
  public:
    ServiceHelper(ros::NodeHandle &nh, const std::string &service_name, boost::python::object &callback_fn)
    {
      py_callback_fn_ = callback_fn;
      service_ = nh.advertiseService(service_name, &pier::ServiceHelper<ReqT, ResT>::callback, this);
    }
    
    bool callback(ReqT &req, ResT &res)
    {
      py_callback_fn_(boost::ref(req), boost::ref(res));
      return true;
    }
    
  private:
    ros::ServiceServer service_;
    boost::python::object py_callback_fn_;
  };


  void ros_init(const std::string &node_name)
  {
    int argc = 0;
    // TODO: use argc and argv passed in from python
    ros::init(argc, (char **)NULL, node_name);
  }
  
  void ros_info(const char *msg_str)
  {
    ROS_INFO("%s", msg_str);
  }

  void ros_debug(const char *msg_str)
  {
    ROS_DEBUG("%s", msg_str);
  }

  void ros_error(const char *msg_str)
  {
    ROS_ERROR("%s", msg_str);
  }

  class ExportRosCPP
  {
  private:
    class_<ros::NodeHandle> node_handle_;
    class_<ros::Publisher> publisher_;
    
  public:
    ExportRosCPP() : node_handle_("NodeHandle"), publisher_("Publisher")
    {
      class_<ros::Duration, boost::noncopyable>("Duration", init<double>());
      class_<ros::Time, boost::noncopyable>("Time", init<double>());
      class_<ros::ServiceServer, boost::noncopyable>("ServiceServer");

      /* should move this to a separate boost.python wrapper around tf */
      class_<tf::TransformListener, boost::noncopyable>(
	"TransformListener", init<ros::Duration, bool>());

      /* ros functions */
      def("init", ros_init);
      def("ros_info", ros_info);
      def("ros_debug", ros_debug);
      def("ros_error", ros_error);
      def("ok", ros::ok);
      def("spin_once", ros::spinOnce);
    }
    
    template <class MsgT>
    void export_msg()
    {
      node_handle_.def("advertise", &ros::NodeHandle::advertise<MsgT>);
      /* we create this function pointer to disambiguate between versions of the overloaded function */
      /* (there is also a version that takes a shared_ptr to a message) */
      void (ros::Publisher::*publish_fn)(const MsgT &) const = &ros::Publisher::publish;
      publisher_.def("publish", publish_fn);
    }

    template <class ReqT, class ResT>
    void export_srv(const char *name)
    {
      class_<pier::ServiceHelper<ReqT, ResT> >(
	name, init<ros::NodeHandle &, const std::string &, boost::python::object &>());
    }
  };
}


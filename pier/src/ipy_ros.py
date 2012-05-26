import sys, os, os.path, re

def set_env(ip, ros_root, ros_master_uri = 'http://localhost:11311', package_paths = []):
    '''
    Setup the environment variables used by ROS programs. Dont need to
    do this if you set these environment variables somewhere else
    (e.g. .bashrc) before launching ipython.
    '''
    global roslib
    os.environ['ROS_ROOT'] = ros_root
    os.environ['PATH'] = '%s/bin:%s' % (ros_root, os.environ['PATH'])
    os.environ['ROS_PACKAGE_PATH'] = ':'.join(package_paths)
    os.environ['ROS_MASTER_URI'] = ros_master_uri

    roslib_pythonpath = os.path.join(ros_root, 'core/roslib/src')
    if 'PYTHONPATH' in os.environ:
        os.environ['PYTHONPATH'] = '%s:%s' % (
            roslib_pythonpath, os.environ['PYTHONPATH'])
    else:
        os.environ['PYTHONPATH'] = roslib_pythonpath

    # since we're doing this after the ipython process has started, setting
    # the PYTHONPATH variable doesn't affect sys.path, and we have to manually
    # update sys.path
    sys.path.append(roslib_pythonpath)

    import roslib

def ros_autocomplete(self, event):
    return ['roscd', 'rosmake', 'rosservice', 'roslaunch', 'rosrun']

def roscd_autocomplete(self, event):
    return roslib.packages.list_pkgs()

def rosmake_autocomplete(self, event):
    return roslib.packages.list_pkgs()

def rosrun_autocomplete(self, event):
    m = re.match('rosrun\s+\S*$', event.line)
    if m:
        # typing package
        return roslib.packages.list_pkgs()
    m = re.match('rosrun\s+(?P<pkg>\S+)\s+\S*', event.line)
    if m:
        # typing executable name
        executables = []
        for subdir in ['bin', 'scripts']:
            executables += roslib.resources.list_package_resources(m.group('pkg'), False, subdir)
        return executables
    return []    

def roslaunch_autocomplete(self, event):
    m = re.match('roslaunch\s+\S*$', event.line)
    if m:
        # typing package
        return roslib.packages.list_pkgs()
    m = re.match('roslaunch\s+(?P<pkg>\S+)\s+\S*', event.line)
    if m:
        # typing launchfile name
        return roslib.resources.list_package_resources(m.group('pkg'), False, 'launch')
    return []

def rosservice_autocomplete(self, event):
    m = re.match('rosservice\s+\S*')
    if m:
        # typing command
        return ['args', 'call', 'find', 'info', 'list', 'type', 'uri']
    return []

def rosload_autocomplete(self, event):
    m = re.match('rosload\s+\S*$', event.line)
    if m:
        # typing package
        return roslib.packages.list_pkgs()

def roscd_func(self, pkg):
    ip = self.api
    ip.runlines('cd %s' % roslib.packages.get_pkg_dir(pkg))

def rosload_func(self, pkg_name):
    '''
    Import roslib, load the manifest for the given package, and import rospy.
    '''
    import roslib
    roslib.load_manifest(pkg_name)
    import rospy
    try:
        __import__(pkg_name)
    except ImportError:
        print 'Package does not appear to have a python module'

def initialize(ip):
    ip.expose_magic('roscd', roscd_func)
    ip.expose_magic('rosload', rosload_func)
    ip.set_hook('complete_command', roscd_autocomplete, re_key='roscd')
    ip.set_hook('complete_command', rosmake_autocomplete, re_key='rosmake')
    ip.set_hook('complete_command', rosservice_autocomplete, re_key='rosservice')
    ip.set_hook('complete_command', roslaunch_autocomplete, re_key='roslaunch')
    ip.set_hook('complete_command', rosload_autocomplete, re_key='rosload')

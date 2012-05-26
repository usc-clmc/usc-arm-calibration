import subprocess, os.path

def ros_packages():
    ''' Make a dictionary such that pkg_dict[pkg_name] = pkg_path '''
    output = subprocess.Popen(
        ['rospack', 'list'], stdout=subprocess.PIPE).communicate()[0]
    lines = output.split('\n')
    pkg_dict = {}
    for l in lines:
        fields = l.split()
        if len(fields) == 2:
            pkg_dict[fields[0]] = fields[1]
    return pkg_dict

def ros_path(pkg_name, path_in_pkg):
    '''
    Return the absolute path of a file/directory in a ROS package,
    given the name of the package and the relative path of the file/directory
    within the package.
    '''
    pkg_dict = ros_packages()
    return os.path.join(pkg_dict[pkg_name], path_in_pkg)

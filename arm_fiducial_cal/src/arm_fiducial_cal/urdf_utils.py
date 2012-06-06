import os.path
import re
import numpy as np

# ROS
import rospy
from geometry_msgs.msg import Transform, Vector3, Quaternion
from tf import transformations

xacro_beg = \
'''
<robot xmlns:sensor="http://playerstage.sourceforge.net/gazebo/xmlschema/#sensor"
       xmlns:controller="http://playerstage.sourceforge.net/gazebo/xmlschema/#controller"
       xmlns:joint="http://playerstage.sourceforge.net/gazebo/xmlschema/#slider"
       xmlns:interface="http://playerstage.sourceforge.net/gazebo/xmlschema/#interface"
       xmlns:body="http://playerstage.sourceforge.net/gazebo/xmlschema/#body"
       xmlns:geom="http://playerstage.sourceforge.net/gazebo/xmlschema/#geom"
       xmlns:xacro="http://ros.org/wiki/xacro">
'''

xacro_end = \
'''
</robot>
'''

property_regex = \
    r'^\s*<xacro:property\s+name=\"(\w+)\"\s+value=\"([-\d\.\s]+)\"\s*/>\s+'


def quaternion_to_rpy(q):
    'Take a Quaternion message and return a numpy rpy vector.'
    q_arr = np.array([q.x, q.y, q.z, q.w])
    R = transformations.quaternion_matrix(q_arr)
    return transformations.euler_from_matrix(R, axes='sxyz')

def vector3_to_array(t):
    'Take a Vector3 message and return a 3 element numpy array.'
    return np.array([t.x, t.y, t.z], dtype=float)

def array_from_string(s):
    'Return a numpy array from string s.'
    return np.array(s, dtype=float)

def formatted_string(values):
    '''
    Return numeric array as formatted string.
    '''
    return "%.6f %.6f %.6f" % tuple(values)

def transform_from_urdf(urdf_file, tf_prefix):
    '''
    Extract and return transform message from URDF file.
    '''
    tf_xyz_str = tf_prefix + "XYZ"
    tf_rpy_str = tf_prefix + "RPY"
    xyz, rpy = (None, None)

    try:
        with open(urdf_file, 'r') as urdf:
            input_lines = urdf.readlines()
    except:
        rospy.logerr("Unable to open file %s for reading, aborting." % urdf_file)
        return

    for line in input_lines:
        match = re.match(property_regex, line)

        if match:
            if match.group(1) == tf_xyz_str:
                xyz = array_from_string(match.group(2))
            elif match.group(1) == tf_rpy_str:
                rpy = array_from_string(match.group(2))

    # Convert to geometry message object.
    if xyz and rpy:
        q = transformations.quaternion_from_euler(*rpy, axes='sxyz')
        return Transform(Vector3(*xyz), Quaternion(*q))

def write_xacro_property(outfile, name, value):
    'Write an xacro property tag to a file.'
    print >> outfile, '<xacro:property name="%s" value="%s" />' % (name, value)

def write_xacro(
        urdf_file, 
        bb_left_neck_tf,
        bb_right_left_tf, 
        ps_bb_left_tf, 
        sr_bb_left_tf):
    outfile = open(urdf_file, 'w+')

    bb_left_xyz = formatted_string(vector3_to_array(bb_left_neck_tf.translation))
    bb_left_rpy = formatted_string(quaternion_to_rpy(bb_left_neck_tf.rotation))

    bb_right_xyz = formatted_string(vector3_to_array(bb_right_left_tf.translation))
    bb_right_rpy = formatted_string(quaternion_to_rpy(bb_right_left_tf.rotation))
    
    ps_xyz = formatted_string(vector3_to_array(ps_bb_left_tf.translation))
    ps_rpy = formatted_string(quaternion_to_rpy(ps_bb_left_tf.rotation))   
    
    sr_xyz = formatted_string(vector3_to_array(sr_bb_left_tf.translation))
    sr_rpy = formatted_string(quaternion_to_rpy(sr_bb_left_tf.rotation))

    print >> outfile, xacro_beg
    write_xacro_property(outfile, 'BBLeftEyeFromNeckXYZ', bb_left_xyz)
    write_xacro_property(outfile, 'BBLeftEyeFromNeckRPY', bb_left_rpy)
    write_xacro_property(outfile, 'BBRightFromLeftXYZ', bb_right_xyz)
    write_xacro_property(outfile, 'BBRightFromLeftRPY', bb_right_rpy) 
    write_xacro_property(outfile, 'ProsilicaFromBBLeftXYZ', ps_xyz)
    write_xacro_property(outfile, 'ProsilicaFromBBLeftRPY', ps_rpy)
    write_xacro_property(outfile, 'SRFromBBLeftXYZ', sr_xyz)
    write_xacro_property(outfile, 'SRFromBBLeftRPY', sr_rpy)   
    print >> outfile, xacro_end

def update_sensors_values_urdf(
        urdf_file,
        bb_left_neck_tf  = None,
        bb_right_left_tf = None,
        ps_bb_left_tf = None,
        sr_bb_left_tf = None):
    '''
    Read, parse and update the sensorsValues.urdf.xacro file for ARM.
    Pass None or an empty list to skip updating a specific transform.
    '''
    try:
        with open(urdf_file, 'r') as urdf:
            input_lines = urdf.readlines()
    except:
        rospy.logerr("Unable to open file %s for reading, aborting." % urdf_file)
        return
       
    output_lines = []   
       
    for line in input_lines:
        match = re.match(property_regex, line)

        if match:
            # Default - original value string...
            value = match.group(2)

            if bb_left_neck_tf:
                if match.group(1) == "BBLeftEyeFromNeckXYZ":
                    value = formatted_string(
                        vector3_to_array(bb_left_neck_tf.translation))
                elif match.group(1) == "BBLeftEyeFromNeckRPY":
                    value = formatted_string(
                        quaternion_to_rpy(bb_left_neck_tf.rotation))
            elif bb_right_left_tf:
                if match.group(1) == "BBRightFromLeftXYZ":
                    value = formatted_string(
                        vector3_to_array(bb_right_left_tf.translation))
                elif match.group(1) == "BBRightFromLeftRPY":
                    value = formatted_string(
                        quaternion_to_rpy(bb_right_left_tf.rotation))
            elif ps_bb_left_tf:
                if match.group(1) == "ProsilicaFromBBLeftXYZ":
                    value = formatted_string(
                        vector3_to_array(ps_bb_left_tf.translation))
                elif match.group(1) == "ProsilicaFromBBLeftRPY":
                    value = formatted_string(
                        quaternion_to_rpy(ps_bb_left_tf.rotation))
            elif sr_bb_left_tf:
                if match.group(1) == "SRFromBBLeftXYZ":
                    value = formatted_string(
                        vector3_to_array(sr_bb_left_tf.translation))
                elif match.group(1) == "SRFromBBLeftRPY":
                    value = formatted_string(
                        quaternion_to_rpy(sr_bb_left_tf.rotation))

            line = match.group(0).replace(match.group(2), value)
        output_lines.append(line)
    
    try:
        with open(urdf_file, 'w+') as urdf:
            urdf.writelines(output_lines)
    except:
        rospy.logerr("Unable to open file %s for writing, aborting." % urdf_file)

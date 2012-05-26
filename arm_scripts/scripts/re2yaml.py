#!/usr/bin/env python
from math import *

import os
import re
import sys
import numpy as np

"""Utility to convert RE2 XML calibration files to YAML format."""

# Required RE2 calibration files.
bblipFname = "bbLeftIntrinsics.xml"
bbldcFname = "bbLeftDistCoeffs.xml"
bbripFname = "bbRightIntrinsics.xml"
bbrdcFname = "bbRightDistCoeffs.xml"
psipFname  = "prosilicaIntrinsics.xml"
psdcFname  = "prosilicaDistCoeffs.xml"

bbRFname = "bbExtrinsicRotation.xml"
bbTFname = "bbExtrinsicTranslation.xml"
psRFname = "proWrtBBExtrinsicRotation.xml"
psTFname = "proWrtBBExtrinsicTranslation.xml"
bbPFname = "bbLeftWrtArm.xml"
srPFname = "srWrtArm.xml"

# Name of head sensor calibration YAML file.
calibFname = "head_calibration.yaml"


def eulerXYZToRotmat(xyz):
    """Euler angles to rotation matrix."""
    r = xyz[0]
    p = xyz[1]
    y = xyz[2]

    R = np.array([[cos(y)*cos(p), \
          cos(y)*sin(p)*sin(r) - sin(y)*cos(r), \
          cos(y)*sin(p)*cos(r) + sin(y)*sin(r)],
         [sin(y)*cos(p), \
          sin(y)*sin(p)*sin(r) + cos(y)*cos(r), \
          sin(y)*sin(p)*cos(r) - cos(y)*sin(r)],
         [-sin(p), cos(p)*sin(r), cos(p)*cos(r)]])
    
    return R

def rotmatToQuat(R):
    """Rotation matrix to unit quaternion."""
    q = np.zeros((4, 1));
    q[0] = 0.5*sqrt(R[0, 0] + R[1, 1] + R[2, 2] + 1)

    if q[0] > 1e-10:
        q[1] = (R[2, 1] - R[1, 2])/(4*q[0])
        q[2] = (R[0, 2] - R[2, 0])/(4*q[0])
        q[3] = (R[1, 0] - R[0, 1])/(4*q[0])
    # More complicated...
    elif R[0, 0] > R[1, 1] and R[0, 0] > R[2, 2]:
        d = 2*sqrt(1 + R(1, 1) - R(2, 2) - R(3, 3))
        q[0] = (R[2, 1] - R[1, 2])/d
        q[1] = d/4
        q[2] = (R[1, 0] + R[0, 1])/d
        q[3] = (R[0, 2] + R[2, 0])/d
    elif R[1, 1] > R[2, 2]:
        d = 2*sqrt(1 + R[1, 1] - R[0, 0] - R[2, 2])
        q[0] = (R[0, 2] - R[2, 0])/d
        q[1] = (R[1, 0] + R[0, 1])/d
        q[2] = d/4
        q[3] = (R[2, 1] + R[2, 3])/d
    else:
        d = 2*sqrt(1 + R[2, 2] - R[0, 0] - R[1, 1])
        q[0] = (R[1, 0] - R[0, 1])/d
        q[1] = (R[0, 2] + R[2, 0])/d
        q[2] = (R[1, 0] + R[1, 2])/d
        q[3] = d/4

    return q

def eposeToHpose(epose):
    """Euler ZYX pose vector to homogeneous pose matrix."""
    # ZYX Euler angles to rotation matrix.
    R = eulerXYZToRotmat(epose[np.ix_([5, 4, 3])])
    
    hpose = np.eye(4)
    hpose[0:3,   3] = epose[0:3]
    hpose[0:3, 0:3] = R

    return np.matrix(hpose)

def hposeCompound(poseA, poseB):
    """Compound operator for homogenous pose matrices."""
    return poseA*poseB

def hposeInverse(pose):
    """Inverse operator for homogeneous pose matrix."""
    return np.linalg.inv(pose)

def getDataFromFile(fname):
    """Pull data from XML file."""
    fi = open(fname, "r")
    content = fi.read()

    # Extract <data>...</data> with regex.
    match = re.search("<data>((.|\s)+)</data>", content)
    return match.group(1).strip()

def re2yaml_BBIntrinsics(xmlDir, outDir, outPrefix):
    """Run converter (Bumblebee2 intrinsics)."""
    # Common l/r.
    bbl = re2yaml_CamIntrinsics(xmlDir, "bbLeft",  640, 480)
    bbr = re2yaml_CamIntrinsics(xmlDir, "bbRight", 640, 480)
    bbR = getDataFromFile(os.path.join(xmlDir, bbRFname))
    bbT = getDataFromFile(os.path.join(xmlDir, bbTFname))
    bbK = getDataFromFile(os.path.join(xmlDir, bblipFname))

    # Parsing to build rectificiation and projection matrices.
    bbRmat = np.fromstring(bbR, np.float64, 9, " ").reshape((3, 3))
    bbKmat = np.fromstring(bbK, np.float64, 9, " ").reshape((3, 3))
    bbTvec = np.fromstring(bbT, np.float64, 3, " ")
    
    # Inverse? Nope, more complicated...
    # bbRmat = hposeInverse(bbRmat)

    # Use intrinsic parameters from left
    # camera for right projection matrix.
    baseline_x = bbKmat[0, 0]*bbTvec[0]
    baseline_y = bbKmat[1, 1]*bbTvec[1]

    # Write YAML file for left camera.
    fo = open(os.path.join(outDir, outPrefix + "_left.yaml"), "w")

    fo.write(bbl)
    fo.write("rectification_matrix:\n")
    fo.write("  rows: 3\n  cols: 3\n")
    fo.write("  data: [1, 0, 0, 0, 1, 0, 0, 0, 1]\n")

    fo.write("projection_matrix:\n")
    fo.write("  rows: 3\n  cols: 4\n")
    fo.write("  data: [%.12f, %.12f, %.12f, %.12f, %.12f, %.12f, " \
                 "%.12f, %.12f, %.12f, %.12f, %.12f, %.12f]\n" %  \
                 (bbKmat[0, 0], bbKmat[0, 1], bbKmat[0, 2], 0, \
                  bbKmat[1, 0], bbKmat[1, 1], bbKmat[1, 2], 0, 0, 0, 1, 0))

    fo.close()

    # Write YAML file for right camera.
    fo = open(os.path.join(outDir, outPrefix + "_right.yaml"), "w")

    fo.write(bbr)
    fo.write("rectification_matrix:\n")
    fo.write("  rows: 3\n  cols: 3\n")
    fo.write("  data: [%.12f, %.12f, %.12f, %.12f, %.12f, " \
                 "%.12f, %.12f, %.12f, %.12f]\n" % \
                 (bbRmat[0, 0], bbRmat[0, 1], bbRmat[0, 2], \
                  bbRmat[1, 0], bbRmat[1, 1], bbRmat[1, 2], \
                  bbRmat[2, 0], bbRmat[2, 1], bbRmat[2, 2]))

    fo.write("projection_matrix:\n")
    fo.write("  rows: 3\n  cols: 4\n")
    fo.write("  data: [%.12f, %.12f, %.12f, %.12f, %.12f, %.12f, " \
                 "%.12f, %.12f, %.12f, %.12f, %.12f, %.12f]\n" %  \
                 (bbKmat[0, 0], bbKmat[0, 1], bbKmat[0, 2], baseline_x, \
                  bbKmat[1, 0], bbKmat[1, 1], bbKmat[1, 2], baseline_y, \
                  0, 0, 1, 0))

    fo.close()
             
def re2yaml_CamIntrinsics(xmlDir, camPrefix, width, height):
    """Run converter (intrinsics)."""
    # Load parameters.
    cami = getDataFromFile(os.path.join(xmlDir, camPrefix + "Intrinsics.xml"))
    camd = getDataFromFile(os.path.join(xmlDir, camPrefix + "DistCoeffs.xml"))
    
    cami = cami.replace("\n", " ").split()
    camd = camd.replace("\n", " ").split()

    # Concatenate as a string.
    yaml  = "image_width: %d\n" % width      # Fill in manually for now, ugh.
    yaml += "image_height: %d\n" % height    # Fill in manually for now, ugh.

    yaml += "camera_name: %s\n" % camPrefix  # Arbitrary, for now.

    yaml += "camera_matrix:\n"
    yaml += "  rows: 3\n  cols: 3\n"
    yaml += "  data: [%s]\n" % ", ".join([val.strip() for val in cami])

    yaml += "distortion_coefficients:\n"
    yaml += "  rows: 1\n  cols: 5\n"
    yaml += "  data: [%s]\n" % ", ".join([val.strip() for val in camd])

    return yaml

def re2yaml_AllExtrinsics(xmlDir, outDir):
    """Run converter (extrinsics)."""
    # Load transforms.
    bbr = getDataFromFile(os.path.join(xmlDir, bbRFname))
    bbt = getDataFromFile(os.path.join(xmlDir, bbTFname))
    psr = getDataFromFile(os.path.join(xmlDir, psRFname))
    pst = getDataFromFile(os.path.join(xmlDir, psTFname))
    bba = getDataFromFile(os.path.join(xmlDir, bbPFname))
    sra = getDataFromFile(os.path.join(xmlDir, srPFname))

    # Compute/convert.
    bbrmat = np.fromstring(bbr, np.float64, 9, " ").reshape((3,3))
    bbrqtn = rotmatToQuat(bbrmat)
    bbtvec = np.fromstring(bbt, np.float64, 3, " ")

    psrmat = np.fromstring(psr, np.float64, 9, " ").reshape((3,3))
    psrqtn = rotmatToQuat(psrmat)
    pstvec = np.fromstring(pst, np.float64, 3, " ")

    bbepose = np.fromstring(bba, np.float64, 6, " ")
    bbhpose = eposeToHpose(bbepose)
    srepose = np.fromstring(sra, np.float64, 6, " ")
    srhpose = eposeToHpose(srepose)
    srhpose = hposeCompound(hposeInverse(bbhpose), srhpose)

    srrqtn = rotmatToQuat(srhpose[0:3, 0:3]) 
    srtvec = srhpose[0:3, 3]

    # Write to YAML file.
    fo = open(os.path.join(outDir, calibFname), "w")

    fo.write("PROSILICA:\n")
    fo.write("  rotation: [%.9f, %.9f, %.9f, %.9f]\n" % tuple(psrqtn))
    fo.write("  translation: [%.9f, %.9f, %.9f]\n" % tuple(pstvec))    
    fo.write("SWISSRANGER:\n")
    fo.write("  rotation: [%.9f, %.9f, %.9f, %.9f]\n" % tuple(srrqtn))
    fo.write("  translation: [%.9f, %.9f, %.9f]\n" % tuple(srtvec))
    fo.write("BUMBLEBEE_RIGHT:\n")
    fo.write("  rotation: [%.9f, %.9f, %.9f, %.9f]\n" % tuple(bbrqtn))
    fo.write("  translation: [%.9f, %.9f, %.9f]\n" % tuple(bbtvec))

    fo.close()

def usage():
    print "re2yaml <RE2 XML directory> <YAML directory> <Bumblebee prefix>"

if __name__ == "__main__":
    if len(sys.argv) < 3:
        usage()
    else:
        re2yaml_AllExtrinsics(*sys.argv[1:3])
        re2yaml_BBIntrinsics(*sys.argv[1:4])

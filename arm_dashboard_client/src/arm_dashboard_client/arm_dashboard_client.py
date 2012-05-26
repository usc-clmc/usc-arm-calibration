'''
Client class for displaying text in the usc dashboard.

2011.4.13 Peter Pastor
'''
#! /usr/bin/env python

import roslib; roslib.load_manifest('arm_dashboard_client')
import rospy

from arm_msgs.msg import StatusReport

class DashboardClient:
    def __init__(self):
        ''' Client class for displaying text in the usc dashboard. '''
        self.publisher = rospy.Publisher('/USCDashboard/status_string', StatusReport)

    def debug(self, status_string):
        ''' Display debug string on usc_dashboard.'''
        status_report = StatusReport()
        status_report.status = status_string
        status_report.mode = StatusReport.DEBUG
        self.publisher.publish(status_report)

    def info(self, status_string):
        ''' Display info string on usc_dashboard.'''
        status_report = StatusReport()
        status_report.status = status_string
        status_report.mode = StatusReport.INFO
        self.publisher.publish(status_report)

    def warn(self, status_string):
        ''' Display warning string on usc_dashboard.'''
        status_report = StatusReport()
        status_report.status = status_string
        status_report.mode = StatusReport.WARN
        self.publisher.publish(status_report)

    def error(self, status_string):
        ''' Display error string on usc_dashboard.'''
        status_report = StatusReport()
        status_report.status = status_string
        status_report.mode = StatusReport.ERROR
        self.publisher.publish(status_report)

    def fatal(self, status_string):
        ''' Display fatal string on usc_dashboard.'''
        status_report = StatusReport()
        status_report.status = status_string
        status_report.mode = StatusReport.FATAL
        self.publisher.publish(status_report)

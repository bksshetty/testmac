#!/usr/bin/python
#  -*- coding: utf-8 -*-

import unittest
import string
import random

from appium import webdriver

class  AppiumTests(unittest.TestCase):

    def setUp(self):
        desired_caps = {}
        desired_caps['platformName'] = 'iOS'
        desired_caps['platformVersion'] = '8.4'
        desired_caps['deviceName'] = 'iPad Air'
        desired_caps['app'] = abspath('/Users/openly/Desktop/AW16.app')
        desired_caps['appiumVersion'] = '1.4.8'
        self.driver = webdriver.Remote('http://127.0.0.1:4723/wd/hub', desired_caps)
        

    def tearDown(self):
        self.driver.quit()

    def testCases(self):
        self.driver.implicitly_wait(60)
        try:
          #  action = TouchAction(self.driver)
          email = self.driver.find_element_by_name('email')
          email.set_value('demo')
          password = self.driver.find_element_by_name('pass')
          password.set_value('test')
          self.driver.find_element_by_name('LOGIN').click()
           # action.tap(el).perform()
        except Exception, e:
            print e
        
        
if __name__ == '__main__':
    suite = unittest.TestLoader().loadTestsFromTestCase(AppiumTests)
    unittest.TextTestRunner(verbosity=2).run(suite)
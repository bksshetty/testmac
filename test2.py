import unittest
from os.path import abspath
from appium import webdriver
from time import sleep
from appium.webdriver.common.touch_action import TouchAction

class  AppiumTests(unittest.TestCase):

    def setUp(self):
        desired_caps = {}
        desired_caps['platformName'] = 'iOS'
        desired_caps['platformVersion'] = '8.4'
        desired_caps['deviceName'] = 'iPad Air'
        desired_caps['app'] = abspath('/Users/distiller/Library/Developer/Xcode/DerivedData/ClarksCollection-alxmlvsmhisrlbcdwhucuoexpvtb/Build/Products/Debug-iphonesimulator/AW16.app')
        desired_caps['appiumVersion'] = '1.4.13'
        self.driver = webdriver.Remote('http://127.0.0.1:4723/wd/hub', desired_caps)
        

    def tearDown(self):
        self.driver.quit()

    def testCases(self):
        self.driver.implicitly_wait(60)
        try:
          #  action = TouchAction(self.driver)
          email = self.driver.find_element_by_name('email')
          email.set_value('em')
          password = self.driver.find_element_by_name('pass')
          password.set_value('test')
          self.driver.find_element_by_name('LOGIN').click()
          self.driver.find_element_by_name('GLOBAL').click()
           # action.tap(el).perform()
        except Exception, e:
            print e
        
        

if __name__ == '__main__':
    suite = unittest.TestLoader().loadTestsFromTestCase(AppiumTests)
    unittest.TextTestRunner(verbosity=2).run(suite)
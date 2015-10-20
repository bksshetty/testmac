"""An example of Appium running on Sauce.
This test assumes SAUCE_USERNAME and SAUCE_ACCESS_KEY are environment variables
set to your Sauce Labs username and access key."""

from random import randint
from appium import webdriver
from appium import SauceTestCase, on_platforms


platforms = [{
                caps['browserName'] = ""
                caps['appiumVersion'] = "1.4.13"
                caps['deviceName'] = "iPad Simulator"
                caps['platformVersion'] = "8.4"
                caps['platformName'] = "iOS"
                caps['app'] = "sauce-storage:AW16.ipa"
            }]

@on_platforms(platforms)
class SimpleIOSSauceTests(SauceTestCase):

    def testCases(self):
        self.driver.implicitly_wait(60)
        try:
          #  action = TouchAction(self.driver)
          email = self.driver.find_element_by_name('email')
          email.set_value('demo')
          password = self.driver.find_element_by_name('pass')
          password.set_value('test')
          self.driver.find_element_by_name('LOGIN').click()
          self.driver.find_element_by_name('GLOBAL').click()
          self.driver.find_element_by_name('APPLY').click()
           # action.tap(el).perform()
        except Exception, e:
            print e
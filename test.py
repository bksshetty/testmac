from random import randint
from appium import webdriver
from appium import SauceTestCase, on_platforms


platforms = [{
                'platformName': 'iOS',
                'platformVersion': '7.1',
                'deviceName': 'iPhone Simulator',
                'app': 'http://appium.s3.amazonaws.com/TestApp6.0.app.zip',
                'appiumVersion': '1.3.4'
            }]

@on_platforms(platforms)
class  AppiumTests(unittest.TestCase):

    def testCases(self):
        self.driver.implicitly_wait(60)
        try:
          #  action = TouchAction(self.driver)
          email = self.driver.find_element_by_name('email')
          email.set_value('demo')
          password = self.driver.find_element_by_name('pass')
          password.set_value('test')
          self.driver.find_element_by_name('LOGIN').click()
          # self.driver.find_element_by_name('GLOBAL').click()
          # self.driver.find_element_by_name('APPLY').click()
          # self.driver.find_element_by_name('CONTINUE').click()
          # self.driver.find_element_by_name('MENU').click()
           # action.tap(el).perform()
        except Exception, e:
            print e

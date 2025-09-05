require 'selenium-webdriver'
require_relative '../support/web_driver_helper'

class BasePage
  include WebDriverHelper

  attr_reader :driver

  def initialize(driver)
    @driver = driver
  end

  def visit(url)
    driver.get(url)
    wait_for_page_load
  end

  def page_title
    driver.title
  end

  def current_url
    driver.current_url
  end

  def wait_for_element(locator, timeout = 10)
    wait = Selenium::WebDriver::Wait.new(timeout: timeout)
    wait.until { driver.find_element(locator) }
  end

  def wait_for_element_to_be_clickable(locator, timeout = 10)
    wait = Selenium::WebDriver::Wait.new(timeout: timeout)
    wait.until { driver.find_element(locator).enabled? }
  end

  def element_present?(locator)
    driver.find_elements(locator).any?
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

  def element_visible?(locator)
    element = driver.find_element(locator)
    element.displayed?
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

  def scroll_to_element(locator)
    element = driver.find_element(locator)
    driver.execute_script("arguments[0].scrollIntoView(true);", element)
  end

  def click_element(locator)
    wait_for_element_to_be_clickable(locator)
    element = driver.find_element(locator)
    scroll_to_element(locator)
    element.click
  end

  def send_keys_to_element(locator, text)
    wait_for_element(locator)
    element = driver.find_element(locator)
    element.clear
    element.send_keys(text)
  end

  def select_dropdown_by_text(locator, text)
    dropdown = Selenium::WebDriver::Support::Select.new(driver.find_element(locator))
    dropdown.select_by(:text, text)
  end

  def select_dropdown_by_value(locator, value)
    dropdown = Selenium::WebDriver::Support::Select.new(driver.find_element(locator))
    dropdown.select_by(:value, value)
  end

  def get_text(locator)
    wait_for_element(locator)
    driver.find_element(locator).text
  end

  def wait_for_page_load
    wait = Selenium::WebDriver::Wait.new(timeout: 30)
    wait.until { driver.execute_script("return document.readyState") == "complete" }
  end

  def take_screenshot(filename = nil)
    filename ||= "screenshot_#{Time.now.strftime('%Y%m%d_%H%M%S')}.png"
    driver.save_screenshot(File.join(Dir.pwd, 'reports', filename))
  end
end

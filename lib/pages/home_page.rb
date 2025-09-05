require_relative 'base_page'
require_relative '../../config/environment'

class HomePage < BasePage
  # Locators
  SIGNUP_LOGIN_BUTTON = { css: 'a[href="/login"]' }.freeze
  HOME_SLIDER = { css: '#slider' }.freeze
  FEATURES_ITEMS = { css: '.features_items' }.freeze
  FOOTER = { css: '#footer' }.freeze

  def initialize(driver)
    super(driver)
  end

  def navigate_to_home
    visit(Config::Environment.base_url)
  end

  def home_page_visible?
    element_visible?(HOME_SLIDER) && 
    element_visible?(FEATURES_ITEMS) && 
    element_visible?(FOOTER)
  end

  def click_signup_login
    click_element(SIGNUP_LOGIN_BUTTON)
  end

  def verify_home_page_title
    expected_title = "Automation Exercise"
    actual_title = page_title
    raise "Expected title '#{expected_title}' but got '#{actual_title}'" unless actual_title.include?(expected_title)
  end
end

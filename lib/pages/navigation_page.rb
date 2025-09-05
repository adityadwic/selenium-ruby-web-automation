require_relative 'base_page'

class NavigationPage < BasePage
  # Locators
  LOGGED_IN_USER = { css: '.navbar-nav li:nth-child(10) a' }.freeze
  DELETE_ACCOUNT_LINK = { css: 'a[href="/delete_account"]' }.freeze
  LOGOUT_LINK = { css: 'a[href="/logout"]' }.freeze

  def initialize(driver)
    super(driver)
  end

  def logged_in_as_username_visible?(username)
    wait_for_element(LOGGED_IN_USER)
    text = get_text(LOGGED_IN_USER)
    text.include?("Logged in as #{username}")
  end

  def get_logged_in_username
    wait_for_element(LOGGED_IN_USER)
    text = get_text(LOGGED_IN_USER)
    text.gsub('Logged in as ', '')
  end

  def click_delete_account
    click_element(DELETE_ACCOUNT_LINK)
  end

  def click_logout
    click_element(LOGOUT_LINK)
  end
end

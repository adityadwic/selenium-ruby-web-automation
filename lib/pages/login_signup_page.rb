require_relative 'base_page'

class LoginSignupPage < BasePage
  # Locators
  NEW_USER_SIGNUP_TEXT = { css: '.signup-form h2' }.freeze
  LOGIN_TO_ACCOUNT_TEXT = { css: '.login-form h2' }.freeze
  SIGNUP_NAME_INPUT = { css: 'input[data-qa="signup-name"]' }.freeze
  SIGNUP_EMAIL_INPUT = { css: 'input[data-qa="signup-email"]' }.freeze
  SIGNUP_BUTTON = { css: 'button[data-qa="signup-button"]' }.freeze
  LOGIN_EMAIL_INPUT = { css: 'input[data-qa="login-email"]' }.freeze
  LOGIN_PASSWORD_INPUT = { css: 'input[data-qa="login-password"]' }.freeze
  LOGIN_BUTTON = { css: 'button[data-qa="login-button"]' }.freeze

  def initialize(driver)
    super(driver)
  end

  def new_user_signup_visible?
    wait_for_element(NEW_USER_SIGNUP_TEXT)
    text = get_text(NEW_USER_SIGNUP_TEXT)
    text.include?('New User Signup!')
  end

  def login_to_account_visible?
    wait_for_element(LOGIN_TO_ACCOUNT_TEXT)
    text = get_text(LOGIN_TO_ACCOUNT_TEXT)
    text.include?('Login to your account')
  end

  def enter_signup_name(name)
    send_keys_to_element(SIGNUP_NAME_INPUT, name)
  end

  def enter_signup_email(email)
    send_keys_to_element(SIGNUP_EMAIL_INPUT, email)
  end

  def click_signup_button
    click_element(SIGNUP_BUTTON)
  end

  def signup_new_user(name, email)
    enter_signup_name(name)
    enter_signup_email(email)
    click_signup_button
  end

  def enter_login_email(email)
    send_keys_to_element(LOGIN_EMAIL_INPUT, email)
  end

  def enter_login_password(password)
    send_keys_to_element(LOGIN_PASSWORD_INPUT, password)
  end

  def click_login_button
    click_element(LOGIN_BUTTON)
  end

  def login_user(email, password)
    enter_login_email(email)
    enter_login_password(password)
    click_login_button
  end
end

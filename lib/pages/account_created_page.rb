require_relative 'base_page'

class AccountCreatedPage < BasePage
  # Locators
  ACCOUNT_CREATED_TEXT = { css: 'h2[data-qa="account-created"]' }.freeze
  CONTINUE_BUTTON = { css: 'a[data-qa="continue-button"]' }.freeze

  def initialize(driver)
    super(driver)
  end

  def account_created_visible?
    wait_for_element(ACCOUNT_CREATED_TEXT)
    text = get_text(ACCOUNT_CREATED_TEXT)
    text.include?('ACCOUNT CREATED!')
  end

  def click_continue
    click_element(CONTINUE_BUTTON)
  end
end

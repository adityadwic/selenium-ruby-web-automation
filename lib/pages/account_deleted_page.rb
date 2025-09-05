require_relative 'base_page'

class AccountDeletedPage < BasePage
  # Locators
  ACCOUNT_DELETED_TEXT = { css: 'h2[data-qa="account-deleted"]' }.freeze
  CONTINUE_BUTTON = { css: 'a[data-qa="continue-button"]' }.freeze

  def initialize(driver)
    super(driver)
  end

  def account_deleted_visible?
    wait_for_element(ACCOUNT_DELETED_TEXT)
    text = get_text(ACCOUNT_DELETED_TEXT)
    text.include?('ACCOUNT DELETED!')
  end

  def click_continue
    click_element(CONTINUE_BUTTON)
  end
end

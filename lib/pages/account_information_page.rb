require_relative 'base_page'

class AccountInformationPage < BasePage
  # Locators
  ENTER_ACCOUNT_INFO_TEXT = { css: '.login-form h2' }.freeze
  TITLE_MR_RADIO = { css: '#id_gender1' }.freeze
  TITLE_MRS_RADIO = { css: '#id_gender2' }.freeze
  NAME_INPUT = { css: '#name' }.freeze
  EMAIL_INPUT = { css: '#email' }.freeze
  PASSWORD_INPUT = { css: '#password' }.freeze
  
  # Date of birth
  BIRTH_DAY_DROPDOWN = { css: '#days' }.freeze
  BIRTH_MONTH_DROPDOWN = { css: '#months' }.freeze
  BIRTH_YEAR_DROPDOWN = { css: '#years' }.freeze
  
  # Checkboxes
  NEWSLETTER_CHECKBOX = { css: '#newsletter' }.freeze
  SPECIAL_OFFERS_CHECKBOX = { css: '#optin' }.freeze
  
  # Address Information
  FIRST_NAME_INPUT = { css: '#first_name' }.freeze
  LAST_NAME_INPUT = { css: '#last_name' }.freeze
  COMPANY_INPUT = { css: '#company' }.freeze
  ADDRESS_INPUT = { css: '#address1' }.freeze
  ADDRESS2_INPUT = { css: '#address2' }.freeze
  COUNTRY_DROPDOWN = { css: '#country' }.freeze
  STATE_INPUT = { css: '#state' }.freeze
  CITY_INPUT = { css: '#city' }.freeze
  ZIPCODE_INPUT = { css: '#zipcode' }.freeze
  MOBILE_NUMBER_INPUT = { css: '#mobile_number' }.freeze
  
  CREATE_ACCOUNT_BUTTON = { css: 'button[data-qa="create-account"]' }.freeze

  def initialize(driver)
    super(driver)
  end

  def enter_account_info_visible?
    wait_for_element(ENTER_ACCOUNT_INFO_TEXT)
    text = get_text(ENTER_ACCOUNT_INFO_TEXT)
    text.include?('ENTER ACCOUNT INFORMATION')
  end

  def select_title(title)
    case title.downcase
    when 'mr'
      click_element(TITLE_MR_RADIO)
    when 'mrs'
      click_element(TITLE_MRS_RADIO)
    else
      raise "Invalid title: #{title}. Use 'Mr' or 'Mrs'"
    end
  end

  def enter_name(name)
    send_keys_to_element(NAME_INPUT, name)
  end

  def enter_password(password)
    send_keys_to_element(PASSWORD_INPUT, password)
  end

  def select_date_of_birth(day, month, year)
    select_dropdown_by_value(BIRTH_DAY_DROPDOWN, day.to_s)
    select_dropdown_by_text(BIRTH_MONTH_DROPDOWN, month)
    select_dropdown_by_value(BIRTH_YEAR_DROPDOWN, year.to_s)
  end

  def check_newsletter
    element = driver.find_element(NEWSLETTER_CHECKBOX)
    element.click unless element.selected?
  end

  def check_special_offers
    element = driver.find_element(SPECIAL_OFFERS_CHECKBOX)
    element.click unless element.selected?
  end

  def fill_address_information(address_data)
    send_keys_to_element(FIRST_NAME_INPUT, address_data[:first_name])
    send_keys_to_element(LAST_NAME_INPUT, address_data[:last_name])
    send_keys_to_element(COMPANY_INPUT, address_data[:company])
    send_keys_to_element(ADDRESS_INPUT, address_data[:address1])
    send_keys_to_element(ADDRESS2_INPUT, address_data[:address2])
    select_dropdown_by_text(COUNTRY_DROPDOWN, address_data[:country])
    send_keys_to_element(STATE_INPUT, address_data[:state])
    send_keys_to_element(CITY_INPUT, address_data[:city])
    send_keys_to_element(ZIPCODE_INPUT, address_data[:zipcode])
    send_keys_to_element(MOBILE_NUMBER_INPUT, address_data[:mobile_number])
  end

  def click_create_account
    scroll_to_element(CREATE_ACCOUNT_BUTTON)
    click_element(CREATE_ACCOUNT_BUTTON)
  end

  def fill_complete_account_info(account_data)
    select_title(account_data[:title])
    enter_password(account_data[:password])
    select_date_of_birth(account_data[:birth_day], account_data[:birth_month], account_data[:birth_year])
    check_newsletter if account_data[:newsletter]
    check_special_offers if account_data[:special_offers]
    fill_address_information(account_data[:address])
    click_create_account
  end
end

require 'selenium-webdriver'
require 'rspec'
require 'rspec/retry'
require 'allure-rspec'
require_relative '../config/environment'
require_relative '../lib/support/web_driver_helper'
require_relative '../lib/support/allure_helper'
require_relative '../lib/support/modern_html_formatter'
require_relative '../lib/support/json_reporter'
require_relative '../lib/support/test_data_helper'

# Require all page objects
Dir[File.join(File.dirname(__FILE__), '../lib/pages/*.rb')].each { |file| require file }

RSpec.configure do |config|
  config.include WebDriverHelper
  # config.include AllureHelper  # Disable for now

  # Retry configuration
  config.verbose_retry = true
  config.default_retry_count = 2
  config.exceptions_to_retry = [Selenium::WebDriver::Error::StaleElementReferenceError]

  config.before(:suite) do
    puts "🚀 Starting Selenium Ruby Test Suite"
    puts "📊 Browser: #{Config::Environment.browser}"
    puts "🌐 Base URL: #{Config::Environment.base_url}"
    puts "👁️  Headless mode: #{Config::Environment.headless}"
    puts "📁 Reports will be generated in: reports/"
    puts "=" * 50
    
    # Ensure reports directory exists
    FileUtils.mkdir_p('reports')
    FileUtils.mkdir_p('reports/allure-results')
    FileUtils.mkdir_p('reports/screenshots')
  end

  config.before(:each) do |example|
    @driver = WebDriverHelper.create_driver
    @driver.manage.window.maximize unless Config::Environment.headless
    @driver.manage.timeouts.implicit_wait = Config::Environment.timeout
    
    # Add Allure metadata (safely handle missing constants)
    begin
      Allure.epic("Automation Exercise")
      Allure.feature("User Registration")
      Allure.story("Complete Registration Flow")
      # Use string instead of constant to avoid errors
      Allure.severity("critical")
      
      # Add test environment info
      Allure.parameter("browser", Config::Environment.browser)
      Allure.parameter("environment", Config::Environment.current_env)
      Allure.parameter("headless", Config::Environment.headless)
    rescue => e
      puts "⚠️  Allure setup warning: #{e.message}"
    end
    
    # Initialize page objects
    @home_page = HomePage.new(@driver)
    @login_signup_page = LoginSignupPage.new(@driver)
    @account_info_page = AccountInformationPage.new(@driver)
    @account_created_page = AccountCreatedPage.new(@driver)
    @navigation_page = NavigationPage.new(@driver)
    @account_deleted_page = AccountDeletedPage.new(@driver)
  end

  config.after(:each) do |example|
    if example.exception && @driver
      # Take screenshot for failed tests
      begin
        timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
        screenshot_name = "failed_#{example.description.gsub(/\s+/, '_')}_#{timestamp}.png"
        screenshot_path = File.join(Dir.pwd, 'reports', 'screenshots', screenshot_name)
        
        @driver.save_screenshot(screenshot_path)
        puts "📸 Screenshot saved: #{screenshot_path}"
        
        # Attach to Allure report (safely)
        begin
          attach_screenshot("Failure Screenshot", screenshot_path)
          attach_page_source("Page Source at Failure")
          attach_browser_logs("Browser Logs")
          
          # Add failure details to Allure
          Allure.step("Test Failed") do
            Allure.parameter("error_message", example.exception.message)
          end
        rescue => e
          puts "⚠️  Allure attachment warning: #{e.message}"
        end
      rescue => e
        puts "❌ Screenshot failed: #{e.message}"
      end
    end
    
    @driver&.quit
  end

  config.after(:suite) do
    puts "=" * 50
    puts "✅ Test suite completed!"
    puts "📊 Check the following reports:"
    puts "   • HTML Report: reports/test_report.html"
    puts "   • Dashboard: reports/dashboard.html"
    puts "   • JSON Data: reports/test_results.json"
    puts "   • Allure Results: reports/allure-results/"
    puts "   • Screenshots: reports/screenshots/"
    puts ""
    puts "🔥 To generate Allure report, run: allure serve reports/allure-results"
    puts "=" * 50
  end

  # Configure formatters
  config.formatter = :documentation
  config.color = true
  config.tty = true
end

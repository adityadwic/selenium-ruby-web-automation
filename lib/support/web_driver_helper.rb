require 'selenium-webdriver'
require_relative '../../config/environment'

module WebDriverHelper
  def self.create_driver
    puts "🔧 Setting up WebDriver for #{Config::Environment.browser}"
    
    options = browser_options

    case Config::Environment.browser.downcase
    when 'chrome'
      # Use local ChromeDriver
      service = Selenium::WebDriver::Service.chrome(path: './drivers/chromedriver')
      Selenium::WebDriver.for(:chrome, service: service, options: options)
    when 'firefox'
      service = Selenium::WebDriver::Service.firefox
      Selenium::WebDriver.for(:firefox, service: service, options: options)
    when 'safari'
      Selenium::WebDriver.for(:safari)
    else
      raise "Unsupported browser: #{Config::Environment.browser}"
    end
  rescue => e
    puts "❌ WebDriver setup failed: #{e.message}"
    puts "🔧 Trying fallback Chrome setup..."
    
    # Fallback to basic chrome setup with local driver
    chrome_options = Selenium::WebDriver::Chrome::Options.new
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument('--disable-web-security')
    chrome_options.add_argument('--headless') if Config::Environment.headless
    
    service = Selenium::WebDriver::Service.chrome(path: './drivers/chromedriver')
    Selenium::WebDriver.for(:chrome, service: service, options: chrome_options)
  end

  def self.browser_options
    case Config::Environment.browser.downcase
    when 'chrome'
      chrome_options
    when 'firefox'
      firefox_options
    else
      nil
    end
  end

  def self.chrome_options
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-gpu')
    options.add_argument('--window-size=1920,1080')
    
    if Config::Environment.headless
      options.add_argument('--headless')
    end
    
    options
  end

  def self.firefox_options
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument('--width=1920')
    options.add_argument('--height=1080')
    
    if Config::Environment.headless
      options.add_argument('--headless')
    end
    
    options
  end

  def quit_driver
    @driver&.quit
  end
end

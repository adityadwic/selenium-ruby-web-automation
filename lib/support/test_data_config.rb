# Sample Test Data Configuration
# You can modify these values or create your own test data

module TestDataConfig
  SAMPLE_USERS = {
    valid_user: {
      name: "John Doe",
      email: "john.doe@example.com",
      title: "Mr",
      password: "SecurePass123!",
      birth_day: 15,
      birth_month: "January",
      birth_year: 1990,
      newsletter: true,
      special_offers: true,
      address: {
        first_name: "John",
        last_name: "Doe",
        company: "Test Company Inc.",
        address: "123 Main Street",
        address2: "Apt 4B",
        country: "United States",
        state: "California",
        city: "San Francisco",
        zipcode: "94102",
        mobile_number: "+1-555-123-4567"
      }
    },
    
    minimal_user: {
      name: "Jane Smith",
      email: "jane.smith@example.com"
    }
  }.freeze

  # Countries available in the dropdown
  AVAILABLE_COUNTRIES = [
    "India", "United States", "Canada", "Australia", 
    "Israel", "New Zealand", "Singapore"
  ].freeze

  # Sample passwords for testing
  SAMPLE_PASSWORDS = [
    "Password123!",
    "SecurePass456@",
    "TestPass789#",
    "AutomationTest2024$"
  ].freeze
end

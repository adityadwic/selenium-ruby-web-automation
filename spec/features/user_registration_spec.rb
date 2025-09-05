require_relative '../spec_helper'

RSpec.describe 'Complete User Registration Flow - 18 Steps', type: :feature do
  before(:each) do
    @user_data = TestDataHelper.generate_user_data
  end

  it 'should complete 18-step user registration and deletion flow', :smoke do
    puts "🚀 Starting Complete 18-Step User Registration Flow"
    
    # Steps 1-2: Launch and Navigate
    puts "📋 Step 1-2: Navigate to home page"
    @home_page.navigate_to_home
    
    # Step 3: Verify home page
    puts "📋 Step 3: Verify home page is visible"
    expect(@home_page.home_page_visible?).to be_truthy
    puts "✅ Home page verified"
    
    # Step 4: Click Signup/Login
    puts "📋 Step 4: Click 'Signup / Login' button"
    @home_page.click_signup_login
    
    # Step 5: Verify New User Signup
    puts "📋 Step 5: Verify 'New User Signup!' is visible"
    expect(@login_signup_page.new_user_signup_visible?).to be_truthy
    puts "✅ Signup form verified"
    
    # Step 6: Enter name and email
    puts "📋 Step 6: Enter name and email address"
    @login_signup_page.enter_signup_name(@user_data[:name])
    @login_signup_page.enter_signup_email(@user_data[:email])
    puts "✅ User data: #{@user_data[:name]} | #{@user_data[:email]}"
    
    # Step 7: Click Signup
    puts "📋 Step 7: Click 'Signup' button"
    @login_signup_page.click_signup_button
    
    # Step 8: Verify Account Info page
    puts "📋 Step 8: Verify 'ENTER ACCOUNT INFORMATION' is visible"
    expect(@account_info_page.enter_account_info_visible?).to be_truthy
    puts "✅ Account info page verified"
    
    # Step 9: Fill account details
    puts "📋 Step 9: Fill details: Title, Password, Date of birth"
    @account_info_page.select_title(@user_data[:title])
    @account_info_page.enter_password(@user_data[:password])
    @account_info_page.select_date_of_birth(@user_data[:day], @user_data[:month], @user_data[:year])
    puts "✅ Account details filled"
    
    # Step 10: Newsletter checkbox
    puts "📋 Step 10: Select newsletter checkbox"
    @account_info_page.check_newsletter
    
    # Step 11: Special offers checkbox
    puts "📋 Step 11: Select special offers checkbox"
    @account_info_page.check_special_offers
    
    # Step 12: Fill address details
    puts "📋 Step 12: Fill address information"
    @account_info_page.fill_address_information(@user_data)
    puts "✅ Address information filled"
    
    # Step 13: Create account
    puts "📋 Step 13: Click 'Create Account' button"
    @account_info_page.click_create_account
    
    # Step 14: Verify account created
    puts "📋 Step 14: Verify 'ACCOUNT CREATED!' is visible"
    expect(@account_created_page.account_created_visible?).to be_truthy
    puts "✅ Account created successfully"
    
    # Step 15: Click Continue
    puts "📋 Step 15: Click 'Continue' button"
    @account_created_page.click_continue
    
    # Step 16: Verify logged in
    puts "📋 Step 16: Verify 'Logged in as username' is visible"
    expect(@navigation_page.logged_in_as_username_visible?(@user_data[:name])).to be_truthy
    puts "✅ Successfully logged in as: #{@user_data[:name]}"
    
    # Step 17: Delete account
    puts "📋 Step 17: Click 'Delete Account' button"
    @navigation_page.click_delete_account
    
    # Step 18: Verify account deleted
    puts "📋 Step 18: Verify 'ACCOUNT DELETED!' and click 'Continue'"
    expect(@account_deleted_page.account_deleted_visible?).to be_truthy
    @account_deleted_page.click_continue
    puts "✅ Account deleted successfully"
    
    puts "\n🎉 ALL 18 STEPS COMPLETED SUCCESSFULLY!"
  end
end

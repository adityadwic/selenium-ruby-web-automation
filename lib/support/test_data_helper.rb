require 'faker'

module TestDataHelper
  def self.generate_user_data
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    
    {
      name: "#{first_name} #{last_name}",
      email: Faker::Internet.unique.email,
      title: ['Mr', 'Mrs'].sample,
      password: Faker::Internet.password(min_length: 8),
      day: rand(1..28).to_s,
      month: Date::MONTHNAMES[rand(1..12)],
      year: rand(1980..2000).to_s,
      newsletter: true,
      special_offers: true,
      first_name: first_name,
      last_name: last_name,
      company: Faker::Company.name,
      address1: Faker::Address.street_address,
      address2: Faker::Address.secondary_address,
      country: 'United States',
      state: Faker::Address.state,
      city: Faker::Address.city,
      zipcode: Faker::Address.zip_code,
      mobile_number: Faker::PhoneNumber.phone_number
    }
  end

  def self.generate_simple_user_data
    {
      name: Faker::Name.name,
      email: Faker::Internet.unique.email
    }
  end
end

require 'factory_girl'

require 'ffaker'

FactoryGirl.define do
  factory :expert do
    # name 'test site'
    # subdomain { "" }
      first_name { Faker::Name.first_name }
      last_name { Faker::Name.last_name }
      profile_title { Faker::Name.last_name }
      services { Faker::Name.last_name }
      tel { Faker::PhoneNumber.phone_number }
      birthdate { Time.at("1920-01-01".to_time.to_f + rand * ("2000-12-31".to_time.to_f - "1920-01-01".to_time.to_f )) }
  end

  factory :invalid_expert, parent: :expert do
      tel "012gf588gh45"
  end
end

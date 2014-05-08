# == Schema Information
#
# Table name: entreprises
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  tel        :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entreprise do
      name { Faker::Company.name }
      tel { Faker::PhoneNumber.short_phone_number }
  end

  factory :invalid_entreprise, parent: :entreprise do
      tel "012tgyugyg4578"
  end
end

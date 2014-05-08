# == Schema Information
#
# Table name: cursus
#
#  id         :integer          not null, primary key
#  diplome    :string(255)
#  university :string(255)
#  years      :integer
#  expert_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cursu do
    diplome { Faker::Education.degree }
    university { Faker::Education.school_name }
    years { rand(1970..1999) }
  end
end

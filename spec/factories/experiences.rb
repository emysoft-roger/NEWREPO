# == Schema Information
#
# Table name: experiences
#
#  id          :integer          not null, primary key
#  entreprise  :string(255)
#  poste       :string(255)
#  description :text
#  expert_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :experience do
    entreprise { Faker::Lorem.words(1) }
    poste { Faker::Lorem.words(1) }
    description { Faker::Lorem.sentences(1) }
  end
end

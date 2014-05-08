# == Schema Information
#
# Table name: notes
#
#  id            :integer          not null, primary key
#  description   :text
#  ponctualite   :float
#  qualite       :float
#  disponibilite :float
#  courtoisie    :float
#  created_at    :datetime
#  updated_at    :datetime
#  expert_id     :integer
#  mission_id    :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :note do
    description { Faker::Lorem.words(50).join(" ") }
    ponctualite { rand(1..5) }
    qualite { rand(1..5) }
    disponibilite { rand(1..5) }
    courtoisie { rand(1..5) }
  end
end

# == Schema Information
#
# Table name: expert_secteurs
#
#  id         :integer          not null, primary key
#  expert_id  :integer
#  secteur_id :integer
#  exp_years  :integer
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :expert_secteur do
    secteur_id { rand(1..8) }
    exp_years { rand(1..19) }
  end
end

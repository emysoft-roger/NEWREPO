# == Schema Information
#
# Table name: expert_competences
#
#  id            :integer          not null, primary key
#  competence_id :integer
#  expert_id     :integer
#  exp_years     :integer
#  created_at    :datetime
#  updated_at    :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :expert_competence do
    competence_id { rand(1..17) }
    exp_years { rand(1..19) }
  end
end

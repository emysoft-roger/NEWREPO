# == Schema Information
#
# Table name: missions
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  entreprise_id :integer
#  budget_min    :integer
#  budget_max    :integer
#  duration_min  :integer
#  duration_max  :integer
#  created_at    :datetime
#  updated_at    :datetime
#  category_id   :integer
#  town          :string(255)
#  postal_code   :string(255)
#  description   :text
#  secteur_id    :integer
#  competence_id :integer
#  validated     :integer
#  validated_at  :datetime
#  state         :integer
#  expert_id     :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mission do
    name { Faker::Lorem.sentence }
    town { Faker::Address.city }
    description { Faker::Lorem.paragraph(3) }
  end

  factory :pending_missions, parent: :mission do
    budget_min 5000
    budget_max 10000

    duration_min 12
    duration_max 24
    category_id 2
    secteur_id 5
    competence_id 12
  end

  factory :invalid_mission, parent: :mission  do
    budget "10000-50000"
    duree "52-520"
    category_id nil
    secteur_id 3
    competence_id 6
  end

  factory :pending_expert_missions, parent: :pending_missions do
    validated 1
    state 3
  end

  factory :pending_admin, parent: :pending_missions do
    validated 0
    state nil
  end

  factory :done_missions, parent: :pending_missions do
    validated 1
    state 2
  end
end

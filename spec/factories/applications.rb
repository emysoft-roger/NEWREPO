# == Schema Information
#
# Table name: applications
#
#  id               :integer          not null, primary key
#  expert_id        :integer
#  mission_id       :integer
#  motivation       :text
#  state            :integer
#  created_at       :datetime
#  updated_at       :datetime
#  price            :float
#  entreprise_price :float
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :application do
    price { rand(10..9999999) }
    motivation { Faker::Lorem.words(50).join(" ") }
  end

  factory :pending_application, parent: :application do
    state 0
  end
end

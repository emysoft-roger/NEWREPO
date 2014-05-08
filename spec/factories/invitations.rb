# == Schema Information
#
# Table name: invitations
#
#  id         :integer          not null, primary key
#  expert_id  :integer
#  mission_id :integer
#  state      :integer
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    expert nil
    mission nil
    state 1
  end
end

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

require 'spec_helper'

describe Mission do
  pending "add some examples to (or delete) #{__FILE__}"
end

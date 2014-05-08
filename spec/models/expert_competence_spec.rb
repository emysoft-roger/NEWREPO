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

require 'spec_helper'

describe ExpertCompetence do
  pending "add some examples to (or delete) #{__FILE__}"
end

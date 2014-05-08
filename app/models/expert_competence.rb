# encoding: utf-8
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

class ExpertCompetence < ActiveRecord::Base
  belongs_to :competence
  belongs_to :expert

  validates :expert_id, presence: true
  validates :competence_id, presence: true
  validates :exp_years, presence: true, length: { in: 1..3 }

  def to_s
    expert_id
  end
end

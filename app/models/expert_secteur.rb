# encoding: utf-8
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

class ExpertSecteur < ActiveRecord::Base
  belongs_to :secteur
  belongs_to :expert

  validates :expert_id, presence: true
  validates :secteur_id, presence: true
  validates :exp_years, presence: true, length: { in: 1..3 }

  def to_s
    expert_id
  end
end

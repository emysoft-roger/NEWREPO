# encoding: utf-8
# == Schema Information
#
# Table name: experiences
#
#  id          :integer          not null, primary key
#  entreprise  :string(255)
#  poste       :string(255)
#  description :text
#  expert_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Experience < ActiveRecord::Base
  belongs_to :expert

  validates :entreprise, presence: true, length: { in: 2..300 }
  validates :poste, presence: true, length: { in: 2..300 }
  validates :description, presence: true, length: { in: 2..800 }
  validates :expert_id, presence: true

  def to_s
    "#{entreprise} (#{poste})"
  end
end

# encoding: utf-8
# == Schema Information
#
# Table name: responsabilities
#
#  id          :integer          not null, primary key
#  organisme   :string(255)
#  poste       :string(255)
#  description :text
#  expert_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Responsability < ActiveRecord::Base
  belongs_to :expert

  validates :organisme, presence: true, length: { in: 2..300 }
  validates :poste, presence: true, length: { in: 2..300 }
  validates :description, presence: true, length: { in: 2..2000 }
  validates :expert_id, presence: true

  def to_s
    "#{organisme} (#{poste})"
  end
end

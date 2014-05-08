# encoding: utf-8
# == Schema Information
#
# Table name: notes
#
#  id            :integer          not null, primary key
#  description   :text
#  ponctualite   :float
#  qualite       :float
#  disponibilite :float
#  courtoisie    :float
#  created_at    :datetime
#  updated_at    :datetime
#  expert_id     :integer
#  mission_id    :integer
#

class Note < ActiveRecord::Base
  belongs_to :expert
  belongs_to :mission

  validates :expert_id, presence: true
  validates :mission_id, presence: true
  validates :ponctualite, presence: true
  validates :qualite, presence: true
  validates :disponibilite, presence: true
  validates :courtoisie, presence: true

  MAPPING_PONDERATION = {
    courtoisie: 0.5,
    disponibilite: 1,
    ponctualite: 1,
    qualite: 2,
  }

  def to_s
    "#{qualite}"
  end

  def self.median
    total = 0

    all.each do |note|
      total += note.median
    end

    if all.count == 0
      0
    else
      (total / all.count)
    end
  end

  def median
    top = 0
    bottom = 0

    MAPPING_PONDERATION.each do |attr, coef|
      note = self.send(attr.to_sym)
      top += note * coef
      bottom += coef
    end
    # raise

    v = (top / bottom)
    v.round(1)
  end
end

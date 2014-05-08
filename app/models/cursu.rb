# encoding: utf-8
# == Schema Information
#
# Table name: cursus
#
#  id         :integer          not null, primary key
#  diplome    :string(255)
#  university :string(255)
#  years      :integer
#  expert_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Cursu < ActiveRecord::Base
  validates :diplome, length: { in: 2..500 }
  validates :university, allow_nil: true, length: { in: 2..500 }
  validates :years, allow_nil: true, length: { is: 4 }

  belongs_to :expert

  def to_s
    "#{diplome} (#{university})"
  end
end

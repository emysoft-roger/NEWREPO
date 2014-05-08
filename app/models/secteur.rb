# encoding: utf-8
# == Schema Information
#
# Table name: secteurs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Secteur < ActiveRecord::Base
  validates :name, uniqueness: true, length: { in: 2..300 }

  has_many :expert_secteurs, dependent: :destroy
  has_many :experts, through: :expert_secteurs
end

# encoding: utf-8
# == Schema Information
#
# Table name: competences
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Competence < ActiveRecord::Base
  validates :name, uniqueness: true, length: { in: 2..500 }
  has_many :expert_competences, dependent: :destroy
  has_many :experts, through: :expert_competences
end

# encoding: utf-8
# == Schema Information
#
# Table name: invitations
#
#  id         :integer          not null, primary key
#  expert_id  :integer
#  mission_id :integer
#  state      :integer
#  created_at :datetime
#  updated_at :datetime
#

class Invitation < ActiveRecord::Base
  # state: 0 (invited), 1, accepted, 2 refused
  belongs_to :expert
  belongs_to :mission

  validates :expert_id, presence: true
  validates :mission_id, presence: true
  validates :state, presence: true

  # validates :expert_id, uniqueness: { scope: :mission_id }

  after_create :send_mails
  attr_accessor :skip_email

  def to_s
    "#{id}"
  end

  def send_mails
    # ASYNC POSSIBLE
    AdminMailer.new_invitation_to_entreprise(self).deliver unless skip_email
    AdminMailer.new_invitation_to_expert(self).deliver unless skip_email
  end

  def refused!
    update(state: 2)
    # ASYNC POSSIBLE
    AdminMailer.refused_invitation_to_entreprise(self).deliver unless skip_email
  end

  def accepted!
    update(state: 1)
  end
end

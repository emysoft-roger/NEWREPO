# encoding: utf-8
# == Schema Information
#
# Table name: applications
#
#  id               :integer          not null, primary key
#  expert_id        :integer
#  mission_id       :integer
#  motivation       :text
#  state            :integer
#  created_at       :datetime
#  updated_at       :datetime
#  price            :float
#  entreprise_price :float
#

# state: 0 pending,
class Application < ActiveRecord::Base
  belongs_to :expert
  belongs_to :mission

  validates :expert_id, presence: true
  validates :mission_id, presence: true
  validates :price, presence: true
  validates :state, presence: true
  validates :motivation, presence: true, length: { in: 2..800 }

  after_create :send_mails

  attr_accessor :skip_email

  def to_s
    "#{price}"
  end

  def self.pendings
    where(state: 0)
  end

  def self.actives
    where(state: 1)
  end

  # def self.done
  #  where(state: 2)
  # end

  def send_mails
    # ASYNC POSSIBLE
    AdminMailer.new_candidate_to_expert(self).deliver unless skip_email
    AdminMailer.new_candidate_to_entreprise(self).deliver unless skip_email
  end

  def pending
    state == 0
  end

  def doing
    state == 1
  end

  def done
    state == 2
  end

  def final_price
    entreprise_price || price
  end

  # Action done by entreprise
  def confirm!(_entreprise_price)
    # pending expert confirmation now
    update(state: 3)
    update(entreprise_price: _entreprise_price) if _entreprise_price.present?

    mission.update(state: 3, expert_id: expert.id)
    send_recrute_mail
  end

  def send_recrute_mail
    # ASYNC POSSIBLE
    AdminMailer.application_validated_to_entreprise(self).deliver unless skip_email
    AdminMailer.application_validated_to_expert(self).deliver unless skip_email
  end
end

# encoding: utf-8
# == Schema Information
#
# Table name: entreprises
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  tel        :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Entreprise < ActiveRecord::Base
  belongs_to :user
  has_many :missions, dependent: :destroy

  after_create :send_mail_entreprise
  attr_accessor :skip_email

  def skip_email!
    self.skip_email = true
  end

  def send_mail_entreprise
    # ASYNC POSSIBLE
    AdminMailer.new_entreprise_to_user(self).deliver unless skip_email
  end

  def active_missions
    missions.joins(:applications).where(applications: { state: 1 }, validated: 1).uniq
  end

  def done_missions
    missions.joins(:applications).where(applications: { state: 2 }, validated: 1).uniq
  end

  def candidatures
    missions.joins(:applications).where(applications: { state: 0 }, validated: 1, state: nil)
  end

  def missions_pending_admin_validation
    missions.where(validated: [nil, 0])
  end

  def possible_missions_for(_expert)
    invited_missions_id = Invitation.where(
                            mission_id: missions.where(validated: 1, state: nil).map!(&:id),
                            expert_id: _expert.id)
                                    .where(state: [0, 1])
                                    .map!(&:mission_id)

    missions.where.not(id: invited_missions_id, validated_at: nil)
            .where(validated: 1, state: nil)
  end

end

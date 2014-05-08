# encoding: utf-8
# == Schema Information
#
# Table name: missions
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  entreprise_id :integer
#  budget_min    :integer
#  budget_max    :integer
#  duration_min  :integer
#  duration_max  :integer
#  created_at    :datetime
#  updated_at    :datetime
#  category_id   :integer
#  town          :string(255)
#  postal_code   :string(255)
#  description   :text
#  secteur_id    :integer
#  competence_id :integer
#  validated     :integer
#  validated_at  :datetime
#  state         :integer
#  expert_id     :integer
#

# state: nil (new), 1: doing, 2: done, 3: pending expert confirmation
class Mission < ActiveRecord::Base
  belongs_to :entreprise
  belongs_to :secteur
  belongs_to :competence
  belongs_to :category
  belongs_to :expert

  has_many :applications
  has_many :invitations
  has_many :notes

  validates :name, presence: true
  validates :description, presence: true

  validates :category_id, presence: true
  validates :entreprise_id, presence: true

  validates :town, presence: true

  validates :budget_min, presence: true
  validates :budget_max, presence: true
  validates :duration_min, presence: true
  validates :duration_max, presence: true

  before_destroy :send_mail_delete

  attr_accessor :skip_email

  STATE_STR = [
    "Nouvelle",
    "En cours",
    "Terminée",
    "Attente expert"
  ]

  def self.searching(params)
    search_query = {
      validated_eq: 1,
      validated_at_not_null: 1,
      state_null: 1
    }

    search_query[:secteur_id_eq] = params["secteur"] if params["secteur"]
    search_query[:competence_id_eq] = params["competence"] if params["competence"]
    search_query[:category_id_eq] = params["category"] if params["category"]

    result = search(search_query)
    result.sorts = 'created_at desc' if result.sorts.empty?

    result
  end

  def self.doing
    where(state: 1, validated: 1)
  end

  def self.done
    where(state: 2, validated: 1)
  end

  def self.pending_expert
    where(state: 3, validated: 1)
  end

  def self.pending
    where(state: nil, validated: 1)
  end

  def self.pending_admin
    where(validated: [nil, 0])
  end

  def skip_email!
    self.skip_email = true
  end

  def send_mail
    # ASYNC POSSIBLE
    AdminMailer.new_mission(self).deliver unless skip_email
  end

  def send_mail_mission
    # ASYNC POSSIBLE
    AdminMailer.new_mission_to_user(self).deliver unless skip_email
  end

  def send_mail_mission_to_experts
    # ASYNC POSSIBLE
    unless skip_email
      Expert.approved.by_competence_id(self.competence_id).each do |expert|
        AdminMailer.new_mission_to_expert(self, expert).deliver
      end
    end
  end

  def send_mail_delete
    # NO ASYNC! We need applications in the mail
    AdminMailer.mission_destroy_to_expert(self).deliver unless skip_email
    applications.destroy_all
  end

  # def requests
  #   []
  # end

  def closed
    doing || done
  end

  def doing
    state == 1
  end

  def done
    state == 2
  end

  def pending_expert
    state == 3
  end

  def validate!
    update(validated_at: Time.now, validated: 0)
    send_mail
    send_mail_mission
  end

  def send_confirmation_mail
    # ASYNC POSSIBLE
    AdminMailer.mission_validated(self).deliver unless skip_email
  end

  def send_refused_mail
    # ASYNC POSSIBLE
    AdminMailer.mission_refused(self).deliver unless skip_email
  end

  def budget_str
    "#{budget_min}-#{budget_max}"
  end

  def duration_str
    "#{duration_min}-#{duration_max}"
  end

  def toggle_activated(kind)
    if kind == "yes"
      if validated == 1
        update_attributes validated: 0
      else
        update_attributes validated: 1
        send_confirmation_mail
        send_mail_mission_to_experts
      end
    else
      update_attributes validated: 0
      send_refused_mail
    end
  end

  def expert_confirm!(infos_bancaire)
    update(state: 1)
    # ASYNC POSSIBLE
    AdminMailer.expert_validate_mission_to_admin(self, infos_bancaire).deliver
    AdminMailer.expert_validate_mission_to_entreprise(self).deliver
    AdminMailer.expert_validate_mission_to_expert(self).deliver
  end

  def expert_reject!
    # NO ASYNC HERE, WE NEED EXPERT RELATION in the mail
    AdminMailer.expert_reject_mission_to_entreprise(self).deliver
    update(state: nil, expert_id: nil)
  end

  def finished!
    update(state: 2)
    # SEND MAIL
  end

  def state_str
    if not state
      index = 0
    else
      index = state
    end

    STATE_STR[index]
  end

  def already_confirmed?
    state == 1
  end

  def application_for(_expert)
    applications.find_by(expert_id: _expert.id, state: 0)
  end

  def invitation_for(_expert)
    invitations.find_by(expert_id: _expert.id, state: 0)
  end

  def price
    @_final_application ||= applications.find_by(state: 3)
    return nil unless @_final_application
    @_final_application.final_price
  end
end

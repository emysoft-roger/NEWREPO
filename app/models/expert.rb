# encoding: utf-8
# == Schema Information
#
# Table name: experts
#
#  id            :integer          not null, primary key
#  first_name    :string(255)
#  last_name     :string(255)
#  tel           :string(255)
#  birthdate     :datetime
#  profile_title :string(255)
#  services      :text
#  user_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#  image_id      :string(255)
#

class Expert < ActiveRecord::Base
  belongs_to :user

  has_many :expert_secteurs, dependent: :destroy
  has_many :expert_competences, dependent: :destroy

  has_many :secteurs, through: :expert_secteurs
  has_many :competences, through: :expert_competences

  has_many :responsabilities, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :cursus, dependent: :destroy

  has_many :applications
  has_many :invitations

  has_many :missions
  has_many :notes

  validates :first_name, presence: true, length: { in: 2..300 }
  validates :last_name, presence: true, length: { in: 2..300 }
  validates :tel, presence: true, length: { in: 1..30 }
  validates :birthdate, presence: true

  validates :profile_title, allow_nil: true, length: { in: 2..800 }
  validates :services, allow_nil: true, length: { in: 3..4000 }

  after_create :send_mail
  attr_accessor :skip_email

  scope :approved,          -> { includes(:user).where(users: { approved: true }) }
  scope :by_competence_id,  ->(competence_id) { includes(:competences).where(competences: { id: competence_id }) }

  def self.searching(params)
    search_query = {
      user_approved_eq: true,
      profile_title_present: 1,
      services_present: 1
    }

    search_query[:secteurs_id_in] = params["secteurs"] if params["secteurs"]
    search_query[:competences_id_in] = params["competences"] if params["competences"]

    result = search(search_query)
    result.sorts = 'created_at desc' if result.sorts.empty?
    result
  end

  def skip_email!
    self.skip_email = true
  end

  def build_new(params)
    _secteurs = build_array(params[:expert_secteur])
    _competences = build_array(params[:expert_competence])
    _experiences = build_array(params[:experience])
    _cursus = build_array(params[:cursu])
    _responsabilities = build_array(params[:responsability])

    expert_secteurs.destroy_all
    expert_secteurs.create(_secteurs)

    expert_competences.destroy_all
    expert_competences.create(_competences)

    experiences.destroy_all
    experiences.create(_experiences)

    cursus.destroy_all
    cursus.create(_cursus)

    responsabilities.destroy_all
    responsabilities.create(_responsabilities)

    self
  end

  def build_array(list)
    return nil unless list

    _list = []

    entries = list.values
    first = entries.first
    quantity = first.size

    quantity.times do |i|
      obj = {}

      list.each do |k, v|
        obj[k] = v[i]
      end

      _list << obj
    end

    _list
  end

  def send_mail
    # ASYNC POSSIBLE
    AdminMailer.new_register(user).deliver unless skip_email
  end

  def send_confirmation_mail
    # ASYNC POSSIBLE
    AdminMailer.expert_validated(self).deliver unless skip_email
  end

  def send_refused_mail
    # ASYNC POSSIBLE
    AdminMailer.expert_refused(self).deliver unless skip_email
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def first_letter
    last_name[0].upcase
  end

  def full?
    !!profile_title && !!services
  end

  def approved?
    user.approved && full?
  end

  def stars
    @_stars ||= (1..note.round(0)).to_a
    @_stars
  end

  def note
    @_note ||= notes.median
    @_note
  end

  def note_median_for(attr)
    total = notes.size
    return nil unless total

    count = 0
    notes.each do |note|
      count += note.send(attr.to_sym)
    end

    (count / total)
  end

  def recommandations
    @_recommandations ||= notes.where("description IS NOT NULL")
    @_recommandations
  end

  def toggle_activated(kind)
    if kind == "yes"
      if user.approved
        user.update_attributes approved: false
      else
        user.update_attributes approved: true
        send_confirmation_mail
      end
    else
      user.update_attributes approved: false
      send_refused_mail
    end
  end

  def pending_missions
    return @_pending_missions if defined?(@_pending_missions)

    @_pending_missions = []

    applications.where(state: 0).includes(:mission).each do |invit|
      @_pending_missions << invit.mission unless invit.mission.state
    end

    @_pending_missions
  end

  def active_missions
    return @_active_missions if defined?(@_active_missions)

    @_active_missions = []

    applications.actives.includes(:mission).each do |application|
      @_active_missions.push application.mission if application.mission
    end

    @_active_missions
  end

  def invited_missions
    return @_invited_missions if defined?(@_invited_missions)
    @_invited_missions = []

    invitations.where(state: 0).includes(:mission).each do |invit|
      @_invited_missions << invit.mission if invit.mission
    end

    @_invited_missions
  end

  def done_missions
    return @_done_missions if defined?(@_done_missions)
    @_done_missions = missions.done
    @_done_missions
  end

  def has_been_invited_to?(mission)
    invited_missions.map(&:id).include?(mission.id)
  end

  def has_candidates_to?(mission)
    active_missions.map(&:id).include?(mission.id) ||
    pending_missions.map(&:id).include?(mission.id) ||
    done_missions.map(&:id).include?(mission.id)
  end

  def has_to_confirm?(mission)
    applications.find_by(state: 3, mission_id: mission.id)
    # pending_missions.map(&:id).include?(mission.id)
  end

  def invit_by(mission)
    invitations.create(mission_id: mission.id, state: 0)
  end
end

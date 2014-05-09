# encoding: utf-8
class MissionsController < ApplicationController
  before_filter :authenticate_entreprise!,
                only: [:new, :preview, :update, :delete,
                       :dashboard, :create_note]

  before_filter :authenticate_expert!,
                only: [:expert_confirm_page, :create_application,
                       :application, :delete_application, :expert_confirm]

  before_filter :current_entreprise_here,
                only: [:dashboard]

  before_filter :preview_only,
                only: [:preview, :update, :delete]

  def index
    @missions = Mission.searching(params.to_hash).result
                       .page(params[:page])
                       .per(10)
                       .includes(:competence, :secteur)
    @categories = Category.all
    @secteurs = Secteur.all
    @competences = Competence.all
  end

  def create
    if mission_params[:id]
      @mission = Mission.find(mission_params[:id])
      @mission.update(mission_params)
    else
      @mission = Mission.new(mission_params)
    end
    @mission.entreprise_id = current_user.entreprise.id

    if @mission.save
      redirect_to preview_path(@mission)
    else
      @categories = Category.all
      @secteurs = Secteur.all
      @competences = Competence.all

      render "new"
    end
  end

  def preview
    @preview = true
    @mission = Mission.find(params[:id])
  end

  def new
    if params[:id]
      @mission = Mission.find(params[:id])
    else
      @mission = Mission.new
    end

    @categories = Category.all
    @secteurs = Secteur.all
    @competences = Competence.all
  end

  def show
    @mission = Mission.find(params[:id])
  end

  def new_entreprise
    @user = User.new
    @entreprise = Entreprise.new
  end

  def update
    @mission = Mission.unscoped.find(params[:id])
    @mission.validate!
    redirect_to entreprise_dashboard_path(current_entreprise.id)
  end

  def create_entreprise
    @user = User.new
    @user.skip_confirmation_notification!

    @user.update(user_params)

    user = @user.save
    @entreprise = Entreprise.new(entreprise_params)
    @entreprise.user_id = @user.id if user

    if user and @entreprise.save
      @user.confirm!
      sign_in :user, @user, bypass: true

      if params[:validate]
        redirect_to new_mission_path
      elsif params[:dashboard]
        redirect_to entreprise_dashboard_path(@entreprise)
      end
    else
      render 'new_entreprise'
    end
  end

  def dashboard
    @entreprise = current_user.entreprise
    @pending_missions_admin = @entreprise.missions.pending_admin

    @pending_missions = @entreprise.missions.pending.includes(:applications, :secteur)
    @pending_expert_missions = @entreprise.missions.pending_expert.includes(:secteur)

    @pending_missions = @pending_expert_missions + @pending_missions

    @candidatures = @entreprise.candidatures
    # @pending_missions.each do |mission|
    #   @candidatures += mission.applications.size
    # end

    @actives_mission = @entreprise.missions.doing.includes(:secteur, :competence)
    @done_mission = @entreprise.missions.done.includes(:secteur, :competence)
  end

  def delete
    mission = Mission.find(params[:id])
    mission.destroy
    redirect_to :back
  end

  def application
    unless current_expert.approved?
      redirect_to :back
      return
    end

    @mission = Mission.find(params[:id])
    @application = Application.new
  end

  def create_application
    unless current_expert.approved?
      redirect_to :back
      return
    end

    application = Application.new(application_params)
    application.expert_id = current_expert.id
    application.state = 0
    application.save

    if params[:invitation_id]
      invitation = Invitation.find(params[:invitation_id])
      return false unless invitation.expert == current_expert
      invitation.accepted!
    end

    redirect_to dashboard_path(current_expert)
  end

  def confirm
    application = Application.find(params[:id])
    application.confirm!(params[:entreprise_price])
    redirect_to entreprise_dashboard_path(current_entreprise.id)
  end

  def delete_application
    application = Application.find(params[:id])
    application.delete
    redirect_to :back
  end

  def expert_confirm
    mission = Mission.find(params[:id])

    if mission.expert_id == current_expert.id
      if params[:confirm]
        mission.expert_confirm!(params[:infos_bancaire])
      else
        mission.expert_reject!
      end
    end

    redirect_to dashboard_path(current_expert)
  end

  def expert_confirm_page
    @mission = Mission.find(params[:id])

    if @mission.already_confirmed?
      redirect_to dashboard_path(current_expert)
    end
  end

  def create_note
    Note.create(note_params)
    mission = Mission.find(note_params[:mission_id])
    mission.finished!
    redirect_to entreprise_dashboard_path(current_entreprise.id)
  end

  private

    # Only allow a trusted parameter "white list" through.
    def entreprise_params
      params.require(:entreprise)
            .permit(:id, :name, :tel)
    end

    def mission_params
      hash = params.require(:mission)
             .permit(:id, :name, :budget, :duree, :description,
                     :town, :category_id, :entreprise_id, :secteur_id,
                     :competence_id)

      duree = hash[:duree].split("-")
      budget = hash[:budget].split("-")

      hash[:duration_min] = duree[0].to_i
      hash[:duration_max] = duree[1].to_i
      hash[:budget_min] = budget[0].to_i
      hash[:budget_max] = budget[1].to_i

      hash.delete(:duree)
      hash.delete(:budget)

      hash
    end

    def user_params
      params.require(:user).permit(:email, :password)
    end

    def application_params
      params.require(:application).permit(:price, :motivation, :mission_id)
    end

    def note_params
      params.require(:note).permit(:description, :expert_id, :mission_id,
                                   :courtoisie, :ponctualite, :qualite,
                                   :disponibilite)
    end

    def current_entreprise_here
      if not current_entreprise or
        current_entreprise.id != params[:id].to_i
        redirect_to root_path
        return
      end
    end

    def preview_only
      mission = Mission.find(params[:id])
      if not current_entreprise or
        mission.entreprise_id != current_entreprise.id
        redirect_to root_path
        return
      end
    end
end

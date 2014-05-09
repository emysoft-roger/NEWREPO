# encoding: utf-8
class ExpertsController < ApplicationController
  before_filter :authenticate_user!,
                only: [:dashboard, :new_profile, :create_profile, :edit_profile]
  before_filter :current_expert_here,
                only: [:dashboard, :edit_profile]
  # before_filter :logged,
                # only: [:create, :new]
  # GET /experts
  def index
    @experts = Expert.searching(params.to_hash).result(distinct: true)
                     .page(params[:page])
                     .per(10)
                     .includes(:expert_secteurs, :expert_competences, :notes)
    @secteurs = Secteur.all
    @competences = Competence.all

    @selected_elem = [params[:secteurs], params[:competences]]
  end

  def photo
    expert = Expert.find(params[:id])

    if params[:img].present?
      img = params[:img]
      # img[public_id]:jxcj2nvjn4fyarkxwjap
      # img[version]:1385995033
      # img[signature]:533986264d90f3371f21ab03ac52d690c64514b4
      # img[width]:300
      # img[height]:121
      # img[format]:png
      # img[resource_type]:image
      # img[created_at]:2013-12-02T14:37:13Z
      # img[bytes]:19336
      # img[type]:upload
      # img[etag]:cc302c3af706ec165f45202f15f3f368
      # img[url]:http://res.cloudinary.com/daf49vcz5/image/upload/v1385995033/jxcj2nvjn4fyarkxwjap.png
      # img[secure_url]:https://res.cloudinary.com/daf49vcz5/image/upload/v1385995033/jxcj2nvjn4fyarkxwjap.png
      # img[path]:v1385995033/jxcj2nvjn4fyarkxwjap.png

      # image/upload/v1234/folder/file.jpg#" + signature

      image_id = "#{img["resource_type"]}/#{img["type"]}/#{img["path"]}##{img["signature"]}"

      preloaded = Cloudinary::PreloadedFile.new(image_id)

      expert.update(image_id: preloaded.identifier) if preloaded.valid?
    end

    render json: { expert_id: expert.id }
  end

  def create
    @user = User.new(user_params)
    @user.skip_confirmation_notification!

    user_save = @user.save
    @expert = Expert.new(expert_params)
    @expert.user_id = @user.id

    if user_save and @expert.save
      @user.confirm!
      sign_in :user, @user, bypass: true
      @user.send_confirmation_instructions
      if params[:validate]
        redirect_to new_profile_path(@expert)
      elsif params[:dashboard]
        redirect_to dashboard_path(@expert)
      end
    else
      render 'new'
    end
  end

  # GET /experts/new
  def new
    @expert = Expert.new
    @user = User.new
    @expert.user = @user
  end

  def home
    render "layouts/home", layout: false
  end

  def dashboard
    @expert = Expert.find(params[:id])
    @pending_applications = @expert.pending_missions

    @_invited_missions = @expert.invited_missions
    @pending_confirm_missions = @expert.missions
                                       .pending_expert
                                       .includes(:secteur, :competence)

    @invited_missions = @pending_confirm_missions + @_invited_missions

    @actives_mission = @expert.missions.doing.includes(:secteur, :competence)
    @missions_done = @expert.missions.done.includes(:secteur, :competence)
  end

  def new_profile
    build_expert
  end

  # GET /experts/1/edit
  def edit_profile
    build_expert
  end

  def create_profile
    @expert = Expert.find(params[:expert][:id])
    @expert.update(expert_params)

    @expert.build_new(params)

    redirect_to dashboard_path(@expert)
  end

  def profile
    @expert = Expert.find(params[:id])
  end

  def invit
    expert = Expert.find(params[:id])
    mission = Mission.find(params[:mission_id])
    expert.invit_by(mission)
    redirect_to entreprise_dashboard_path(current_entreprise.id)
  end

  def refused_invitation
    invitation = Invitation.find(params[:id])
    invitation.refused!
    redirect_to :back
  end

  private

    # Only allow a trusted parameter "white list" through.
    def expert_params
      params.require(:expert)
            .permit(:id, :profile_title, :services, :first_name,
                    :last_name, :tel, :birthdate)
    end

    def user_params
      params.require(:user).permit(:email, :password)
    end

    def build_expert
      @expert = Expert.find(params[:id])

      @expert.expert_secteurs.build if @expert.expert_secteurs.empty?
      @expert.expert_competences.build if @expert.expert_competences.empty?
      @expert.experiences.build if @expert.experiences.empty?
      @expert.cursus.build if @expert.cursus.empty?
      @expert.responsabilities.build if @expert.responsabilities.empty?

      @secteurs = Secteur.all
      @competences = Competence.all
    end

    def current_expert_here
      if not current_expert or
         current_expert.id != params[:id].to_i
        redirect_to root_path
        return
      end
    end
end

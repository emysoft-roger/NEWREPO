# encoding: utf-8
class AdminMailer < ActionMailer::Base
  default from: "contact@louerunsenior.com"

  def contact(data)
    @data = data
    @data['content'] = @data['content'].gsub(/\n/, "<br>")

    mail to: "contact@louerunsenior.com",
         subject: "[LouerUnSenior] Contact (par #{@data['name']})"
  end

  def new_register(user)
    @user = user
    admins_email = AdminUser.pluck(:email)
    mail to: admins_email,
         subject: "[LouerUnSenior] Nouvel utilisateur inscrit : #{@user.expert.full_name}"
  end

  def new_mission(mission)
    @mission = mission

    admins_email = AdminUser.pluck(:email)
    mail to: admins_email,
         subject: "[LouerUnSenior] Nouvelle mission à valider : #{@mission.name}"
  end

  def expert_validated(expert)
    @expert = expert
    mail to: expert.user.email,
         subject: "[LouerUnSenior] Votre compte est activé et public"
  end

  def expert_refused(expert)
    @expert = expert
    mail(to: expert.user.email, subject: "[LouerUnSenior] Votre compte n'a pas été validé")
  end

  def mission_validated(mission)
    @mission = mission
    @entreprise = mission.entreprise
    mail(to: @entreprise.user.email, subject: "[LouerUnSenior] Votre mission est validée et publique")
  end

  def mission_refused(mission)
    @mission = mission
    @entreprise = mission.entreprise
    mail(to: @entreprise.user.email, subject: "[LouerUnSenior] Votre mission n'a pas été validée")
  end

  def new_mission_to_expert(mission, expert)
    @expert     = expert
    @mission    = mission
    mail(to: @expert.user.email, subject: "[LouerUnSenior] Une nouvelle mission est susceptible de vous intéresser")
  end

  def new_mission_to_user(mission)
    @mission = mission
    @entreprise = mission.entreprise
    mail(to: @entreprise.user.email, subject: "[LouerUnSenior] Mission déposée")
  end

  def new_entreprise_to_user(entreprise)
    @entreprise = entreprise
    mail(to: entreprise.user.email, subject: "[LouerUnSenior] Confirmation d'inscription")
  end

  def new_candidate_to_entreprise(application)
    @expert = application.expert
    @mission = application.mission
    @entreprise = @mission.entreprise
    mail(to: @entreprise.user.email, subject: "[LouerUnSenior] Un expert a postulé pour la mission : #{@mission.name}")
  end

  def new_candidate_to_expert(application)
    @expert = application.expert
    @mission = application.mission
    @entreprise = @mission.entreprise
    mail(to: @expert.user.email, subject: "[LouerUnSenior] Confirmation candidature")
  end

  def new_invitation_to_entreprise(invitation)
    @invitation = invitation
    @mission = invitation.mission
    @expert = @invitation.expert
    @entreprise = @mission.entreprise
    mail(to: @entreprise.user.email, subject: "[LouerUnSenior] Confirmation de l'invitation")
  end

  def new_invitation_to_expert(invitation)
    @invitation = invitation
    @mission = invitation.mission
    @entreprise = @mission.entreprise
    @expert = invitation.expert
    mail(to: @invitation.expert.user.email, subject: "[LouerUnSenior] Une entreprise vous invite à postuler")
  end

  def mission_destroy_to_expert(mission)
    mission.applications.each do |application|
      @application = application
      @expert = application.expert
      @mission = mission
      @entreprise = @mission.entreprise
      mail(to: @expert.user.email, subject: "[LouerUnSenior] Mission supprimée par l'entreprise")
    end
  end

  def refused_invitation_to_entreprise(invitation)
    @invitation = invitation
    @expert = invitation.expert
    @mission = invitation.mission
    @entreprise = @mission.entreprise
    mail(to: @entreprise.user.email, subject: "[LouerUnSenior] Invitation refusée par l'expert")
  end

  def application_validated_to_entreprise(application)
    @mission = application.mission
    @expert = application.expert
    @entreprise = @mission.entreprise
    mail(to: @entreprise.user.email, subject: "[LouerUnSenior] Confirmation du choix de l'expert")
  end

  def application_validated_to_expert(application)
    @mission = application.mission
    @expert = application.expert
    @entreprise = @mission.entreprise
    mail(to: @expert.user.email, subject: "[LouerUnSenior] Votre candidature a été retenue")
  end

  def expert_reject_mission_to_entreprise(mission)
    @mission = mission
    @expert = mission.expert
    @entreprise = mission.entreprise
    mail(to: @entreprise.user.email, subject: "[LouerUnSenior] L'expert n'a pas confirmé la participation")
  end

  def expert_validate_mission_to_entreprise(mission)
    @mission = mission
    @expert = mission.expert
    @entreprise = mission.entreprise
    mail(to: @entreprise.user.email, subject: "[LouerUnSenior] Confirmation de la participation de l'expert")
  end

  def expert_validate_mission_to_expert(mission)
    @mission = mission
    @expert = mission.expert
    @entreprise = mission.entreprise
    mail(to: @expert.user.email, subject: "[LouerUnSenior] Confirmation de la participation à la mission : #{@mission.name}")
  end

  def expert_validate_mission_to_admin(mission, infos_bancaire)
    @mission = mission
    @expert = mission.expert
    @entreprise = mission.entreprise
    @infos_bancaire = infos_bancaire

    admins_email = AdminUser.pluck(:email)

    mail to: admins_email,
         subject: "[LouerUnSenior] Infos bancaires, confirmation de la participation à la mission : #{@mission.name}"
  end

end

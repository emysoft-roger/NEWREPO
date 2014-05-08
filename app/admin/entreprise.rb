# encoding: utf-8
ActiveAdmin.register Entreprise do

  action_item only: :show do
    link_to "En tant que", log_as_path(user_id: entreprise.user.id), class: "member_link", target: "_blank"
  end

  action_item only: :edit do
    link_to "Editer Email", edit_admin_user_path(entreprise.user), class: "member_link"
  end

  index do
    column(:id)
    column(:tel)
    column(:name)
    column(:email) { |entreprise| entreprise.user.email if entreprise.user }
    column("Candidatures") { |entreprise| entreprise.candidatures.size }
    column("En attente Admin") { |entreprise| entreprise.missions_pending_admin_validation.size }
    column("En attente") { |entreprise| entreprise.missions.pending.size }
    column("En cours") { |entreprise| entreprise.missions.doing.size }
    column("Terminées") { |entreprise| entreprise.missions.done.size }
    column(:created_at)

    actions defaults: false do |post|
      link_to "Edit", edit_admin_entreprise_path(post), class: "member_link"
    end

    actions defaults: false do |post|
      link_to "En tant que", log_as_path(user_id: post.user.id), class: "member_link", target: "_blank"
    end

  end

  controller do
    def permitted_params
      params.permit(entreprise: [:name, :tel])
    end
  end

end

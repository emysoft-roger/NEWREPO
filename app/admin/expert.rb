# encoding: utf-8
ActiveAdmin.register Expert do

  action_item only: :show do
    link_to "Se connecter en tant que", log_as_path(user_id: expert.user.id), class: "member_link", target: "_blank"
  end

  action_item only: :show do
    link_to "Editer Email", edit_admin_user_path(expert.user), class: "member_link"
  end

  index do
    column(:id)
    column("Nom", sortable: :first_name) { |expert| "#{expert.first_name} #{expert.last_name}" }
    column("Date de Naissance", sortable: :birthdate) { |expert| expert.birthdate.strftime("%d/%m/%Y")  }
    column(:email) { |expert| expert.user.email if expert.user }
    # column("Titre") { |expert| expert.profile_title }
    # column("Description") { |expert| expert.services }
    column("Créé le", sortable: :created_at) { |expert| expert.created_at.strftime("%d/%m/%Y") }
    column("Notes") { |expert| expert.notes.size }
    column("Moyenne") { |expert| expert.notes.median.round(1) }
    column("Candidatures") { |expert| expert.pending_missions.size }
    column("Mission en cours") { |expert| expert.missions.doing.size }
    column("Mission terminées") { |expert| expert.missions.done.size }

    actions(defaults: false) do |post|
      text = "Confirmer"
      unless post.user.approved
        link_to text, activate_admin_expert_path(post, kind: :yes),
                "data-method" => :post, class: "member_link"
      end
    end

    actions(defaults: false) do |post|
      text = "Refuser"
      unless post.user.approved
        link_to text, activate_admin_expert_path(post, kind: :no),
                "data-method" => :post, class: "member_link"
      end
    end

    actions(defaults: false) do |post|
      link_to "Voir", admin_expert_path(post), class: "member_link"
    end

    actions(defaults: false) do |post|
      link_to "Voir en ligne", profile_path(post), class: "member_link"
    end

    actions(defaults: false) do |post|
      link_to "En tant que", log_as_path(user_id: post.user.id), class: "member_link", target: "_blank"
    end

  end

  member_action :activate, method: :post do
    resource.toggle_activated(params[:kind])
    redirect_to :back
  end

  show do |u|
    attributes_table do
      row :first_name
      row :last_name
      row :tel
      row "titre" do
        u.profile_title
      end
      row :description do
        u.services
      end

      row :email do
        u.user.email
      end

      row "Créé le" do
        u.created_at
      end
    end

    # columns do
      # panel 'Treatments' do
      # end
    # end # columns
    #   column do
    #     panel 'Treatments' do
    #       table_for(establishment.treatments) do |t|
    #         t.column('name') { |item| link_to item.name , '#' }
    #         t.column('category') { |item| item.category }
    #         t.column('description')   { |item|  item.description }
    #         t.column('duration')   { |item|  item.duration }
    #         t.column('price')   { |item|  item.price }
    #       end
    #     end
    #   end
  end

  controller do
    def permitted_params
      params.permit(expert: [:user_id, :first_name, :last_name, :tel,
                             :birthdate, :profile_title, :services])
    end
  end
end

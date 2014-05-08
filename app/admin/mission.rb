# encoding: utf-8
ActiveAdmin.register Mission do

  index do
    column :id
    column :name
    column "Durée", sortable: :duration_min do |i|
      mapping_duree(i)
    end
    column :budget, sortable: :budget_min  do |i|
      mapping_budget(i)
    end

    column "Ville", sortable: :town do |i|
      "#{i.town} #{i.postal_code}"
    end

    column "Status", sortable: :state do |i|

      # status_tag (task.is_done ? "Done" : "Pending"), (task.is_done ? :ok : :error)

      i.state_str
    end

    column "Par entreprise" do |i|
      link_to i.entreprise.name, admin_entreprise_path(i.entreprise)
    end

    column "Prix" do |i|
      if i.price
        i.price.round(0)
      else
        "-"
      end
    end

    column :created_at

    actions(defaults: false) do |i|
      text = "Confirmer"
      unless i.validated == 1
        link_to text, activate_admin_mission_path(i, kind: :yes),
                "data-method" => :post, class: "member_link"
      end
    end

    actions(defaults: false) do |i|
      text = "Refuser"
      unless i.validated == 1
        link_to text, activate_admin_mission_path(i, kind: :no),
                "data-method" => :post, class: "member_link"
      end
    end

    actions(defaults: false) do |i|
      link_to "Voir", admin_mission_path(i), class: "member_link"
    end
  end

  member_action :activate, method: :post do
    resource.toggle_activated(params[:kind])
    redirect_to :back
  end

    form do |f|
      f.inputs "Details" do
        f.input :name
        f.input :description
        f.input :town
        f.input :postal_code
        f.input :state
        f.input :validated
        f.input :validated_at
        f.input :created_at, :label => "Créée le "
        f.input :updated_at, :label => "Modifiée le "
      end

      # f.inputs "Budget + Durée. Ne pas éditer." do
        # f.input :budget_min
        # f.input :budget_max
        # f.input :duration_min
        # f.input :duration_max
      # end

      f.inputs "Liens" do
        f.input :expert
        f.input :entreprise
        f.input :secteur
        f.input :competence
        f.input :category
      end
      f.actions
    end

  controller do
    def permitted_params
      params.permit(mission: Mission.new.attributes.keys)
    end
  end
end

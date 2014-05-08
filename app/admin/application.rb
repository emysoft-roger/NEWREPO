# encoding: utf-8
ActiveAdmin.register Application, as: "Candidatures" do

  index do
    column(:id)
    column(:price)
    column(:motivation)
    column("Etat") { |u| u.state }
    column(:expert)
    column(:mission)
    column(:entreprise) { |i| link_to i.mission.entreprise.name, admin_entreprise_path(i.mission.entreprise.id) }
    column(:created_at)
  end
end

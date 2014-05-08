# encoding: utf-8
LouerunseniorRails::Application.routes.draw do
  root "experts#home"

  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_scope :user do
    get "/sign_out" => "devise/sessions#destroy"
  end

  get "/missions" => "missions#index", as: "missions"
  get "/missions/new" => "missions#new", as: "new_mission"
  get "/missions/:id" => "missions#show", as: "mission"
  delete "/missions/:id" => "missions#delete"

  get "/missions/:id/application" => "missions#application", as: "application"
  post "/missions/:id/application" => "missions#create_application"
  patch "/applications/:id" => "missions#confirm", as: "confirm_application"
  delete "/applications/:id" => "missions#delete_application"

  patch "/missions/:id" => "missions#update"
  get "/missions/:id/preview" => "missions#preview", as: "preview"
  post "/missions" => "missions#create"
  get "/missions/:id/confirm" => "missions#expert_confirm_page", as: "expert_confirm"
  patch "/missions/:id/confirm" => "missions#expert_confirm"

  get "/entreprises/new" => "missions#new_entreprise", as: "new_entreprise"
  get "/entreprises/:id/dashboard" => "missions#dashboard", as: "entreprise_dashboard"
  post "/entreprises" => "missions#create_entreprise", as: "entreprises"
  post "/notes" => "missions#create_note", as: "notes"
  # post "/missions/new/depot" => "missions#create_depot"


  get "/experts" => "experts#index", as: "experts"
  get "/experts/new" => "experts#new", as: "new_expert"
  post "/experts" => "experts#create"
  post "/experts/:id/photo" => "experts#photo"

  get "/experts/:id/profile/new" => "experts#new_profile", as: "new_profile"
  get "/experts/:id/dashboard" => "experts#dashboard", as: "dashboard"
  get "/experts/:id/edit" => "experts#edit_profile", as: "edit_profile"

  get "/experts/:id" => "experts#profile", as: "profile"
  post "/experts/profile" => "experts#create_profile", as: "create_profile"
  post "/experts/:id/invit" => "experts#invit", as: "invit"

  patch "/invitations/:id" => "experts#refused_invitation", as: "invitation"

  get "/comment-ca-marche-entreprise" => "pages#commentmarche-entreprise", as: "comment_ca_marche"
  get "/comment-ca-marche-expert" => "pages#commentmarche-expert", as: "comment_ca_marche_expert"
  get "/contact" => "pages#contact", as: "contact"
  post "/contact" => "pages#post_contact"
  get "/cgu-cgv" => "pages#cgucgv", as: "cgu_cgv"
  get "/mentions-legales" => "pages#mentionslegales", as: "mentions_legales"
  get "/equipe" => "pages#equipe", as: "equipe"
  get "/contrat-apporteur-affaires" => "pages#apporteuraffaires", as: "apporteuraffaires"

  # ADMIN
  get "/log_as" => "application#log_as", as: "log_as"

end

# encoding: utf-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # Test de rapatriement
  protect_from_forgery with: :exception
  before_action :set_default_language

  helper_method :current_expert
  helper_method :current_entreprise

  def set_default_language
    I18n.locale = 'fr'
  end

  def current_expert
    return nil unless current_user
    @_current_expert ||= current_user.expert
  end

  def current_entreprise
    return nil unless current_user
    @_current_entreprise ||= current_user.entreprise
  end

  def authenticate_expert!
    redirect_to root_path unless current_expert
  end

  def authenticate_entreprise!
    redirect_to root_path unless current_entreprise
  end

  def log_as
    unless current_admin_user
      redirect_to root_path
      return
    end

    user = User.find(params[:user_id])
    sign_in :user, user, bypass: true

    if user.expert
      redirect_to dashboard_path(user.expert.id)
    else
      redirect_to entreprise_dashboard_path(user.entreprise.id)
    end
  end

  def after_sign_in_path_for(resource)
    if defined?(resource.expert) and resource.expert
      return dashboard_path(resource.expert)
    end

    if defined?(resource.entreprise) and resource.entreprise
      return entreprise_dashboard_path(resource.entreprise)
    end

    super
  end
end

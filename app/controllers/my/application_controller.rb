# encoding: utf-8

class My::ApplicationController < ApplicationController
  inherit_resources

  helper_method :namespace

  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to new_my_session_path, :notice => "У вас не хватает прав для выполнения этого действия"
  end

  def namespace
    params[:controller].split('/').first
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, namespace)
  end
end

# encoding: utf-8

class My::ApplicationController < ApplicationController
  inherit_resources

  helper_method :namespace
  before_filter :check_current_user

  check_authorization

  def namespace
    params[:controller].split('/').first
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, namespace)
  end

  private
  def check_current_user
    redirect_to new_my_session_path unless current_user
  end
end

# encoding: utf-8

class My::ApplicationController < ApplicationController
  inherit_resources

  helper_method :namespace

  load_and_authorize_resource
  check_authorization

  def namespace
    params[:controller].split('/').first
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, namespace)
  end
end

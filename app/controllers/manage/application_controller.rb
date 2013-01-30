class Manage::ApplicationController < InheritedResources::Base
  helper_method :per_page

  layout 'manage'

  before_filter :sign_in_if_not_authorized
  load_and_authorize_resource

  private

  def per_page
    @per_page ||= Settings['pagination.per_page'] || 10
  end

  def current_user
    @current_user ||= User.find_by_oauth_key(session[:oauth_key]) if session[:oauth_key]
  end

  def sign_in_if_not_authorized
    redirect_to new_manage_session_path unless current_user
  end

  helper_method :current_user
end

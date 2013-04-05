class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :authenticate

  def vkontakte
  end

  def google_oauth2
  end

  def yandex
  end

  def facebook
  end

  def after_sign_in_path_for(resource_or_scope)
    return crm_root_path    if current_user.is_sales_manager?
    return manage_root_path if current_user.is_admin?

    request.env['omniauth.origin'] if request.env['omniauth.origin']
  end

  private

  def authenticate
    @user = User.find_or_create_by_oauth(request.env['omniauth.auth'])

    sign_in_and_redirect @user, :event => :authentication
  end
end

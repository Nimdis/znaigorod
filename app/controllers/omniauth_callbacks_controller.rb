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

  def twitter
  end

  def after_sign_in_path_for(resource_or_scope)
    request.env['omniauth.origin'] if request.env['omniauth.origin']
  end

  private

  def authenticate
    @user = User.find_or_create_by_oauth(request.env['omniauth.auth'])

    sign_in @user, :event => :authentication

    @after_sign_in_url = after_sign_in_path_for(@user)

    render 'callback', :layout => false
  end
end

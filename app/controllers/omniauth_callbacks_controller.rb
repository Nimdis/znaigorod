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

  def odnoklassniki
  end

  def mailru
  end

  def after_sign_in_path_for(resource_or_scope)
    return my_root_path if request.env['omniauth.origin'].match(/my\/sessions\/new/)
    return request.env['omniauth.origin'] if request.env['omniauth.origin']

    root_path
  end

  private

  def authenticate
    @user = User.find_or_create_by_oauth(request.env['omniauth.auth'])
    sign_in @user, :event => :authentication
    @after_sign_in_url = after_sign_in_path_for(@user)

    if @after_sign_in_url.match(/manage/)
      redirect_to(manage_root_path)
    elsif @after_sign_in_url.match(/my\z/)
      redirect_to(my_root_path)
    else
      render('callback', :layout => false)
    end
  end
end

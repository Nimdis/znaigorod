#encoding:utf-8
class Manage::SessionsController < ApplicationController
  def new
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_oauth_key(auth.credentials.token)
    if user = User.find_by_uid(auth.uid)
      user.oauth_key = auth.credentials.token
      user.name = auth.info.name
      user.save!
    end

    if user.nil?
      redirect_to new_manage_session_path, notice: "Вы не являетесь пользователем данной системы"
    else
      if user.roles.any?
        session[:oauth_key] = user.oauth_key
        redirect_to [:manage, :root] and return if user.is? :admin
        redirect_to [:manage, user.roles.first.split("_").first]
      else
        redirect_to new_manage_session_path, :notice => "У вас нет прав доступа в систему"
      end
    end
  end

  def destroy
    reset_session
    redirect_to root_path, :notice => "Logged out!"
  end
end

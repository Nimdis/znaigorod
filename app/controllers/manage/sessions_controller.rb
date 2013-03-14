#encoding:utf-8
class Manage::SessionsController < ApplicationController
  def new
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_oauth_key(auth.credentials.token)
    if user = User.find_by_uid(auth.uid)
      user.oauth_key = auth.credentials.token
      user.name = auth.info.nickname
      user.save!
    end
    session[:oauth_key] = user.oauth_key unless user.nil?

    if user.roles.any?
      redirect_to [:manage, :root] and return if user.is? :admin
      redirect_to [:manage, user.roles.first.split("_").first]
    else
      render :new, :notice => "У вас нет прав доступа в систему"
    end
  end

  def destroy
    reset_session
    redirect_to root_path, :notice => "Logged out!"
  end
end

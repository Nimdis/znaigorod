class Manage::SessionsController < ApplicationController
  def new
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_oauth_key(auth.credentials.token) ||
           User.create!(:oauth_key => auth.credentials.token)

    session[:oauth_key] = user.oauth_key
    redirect_to manage_root_path, :notice => "Logged in!"
  end

  def destroy
    reset_session
    redirect_to root_path, :notice => "Logged out!"
  end
end

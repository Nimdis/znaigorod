class Manage::Admin::UsersController < Manage::ApplicationController
  actions :show

  def index
    @users = if params[:filter]
               User.with_role(params[:filter])
             else
               User.where(:roles_mask => nil)
             end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to manage_admin_users_path
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes!(params[:user])
      redirect_to manage_admin_user_path(@user)
    else
      render :action => "edit"
    end
  end

  def mass_update
    params[:users].each do |id|
      user = User.find(id)
      user.roles = user.roles | [params[:role]] and user.save!
    end

    redirect_to manage_admin_users_path
  end

end

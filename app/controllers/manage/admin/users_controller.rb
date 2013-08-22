class Manage::Admin::UsersController < Manage::ApplicationController
  actions :index, :edit, :update, :destroy

  protected
  def collection
    @users = User.search{
      keywords params[:q]
      paginate paginate_options.merge(:per_page => 20)
    }.results
  end
end

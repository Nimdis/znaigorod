class FollowersController < ApplicationController
  def index
    @account = Account.find(params[:account_id])
    @followers = @account.followers(Account)
  end
end

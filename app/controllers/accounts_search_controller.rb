class AccountsSearchController < ApplicationController
  layout false

  respond_to :json

  def show
    @accounts = Account.search { keywords params[:q] }.results

    render :partial => 'results'
  end
end

class AccountsSearchController < ApplicationController
  layout false

  respond_to :json

  def show
    page = params[:page].to_i.zero? ? 1 : params[:page]

    @accounts = Account.search {
      keywords params[:q]
      paginate :page => page, :per_page => 1
    }.results

    render :partial => 'results'
  end
end

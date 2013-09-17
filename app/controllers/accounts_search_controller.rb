class AccountsSearchController < ApplicationController
  layout false

  helper_method :parent

  def show
    page = params[:page].to_i.zero? ? 1 : params[:page]
    per_page = 10

    if params[:only_friends]
      friends = Friend.search {
        keywords params[:q]
        with :account_id, current_user.account.id
        paginate :page => page, :per_page => per_page
      }.results

      @accounts = Account.where(:id => friends.map(&:friendable_id)).page(page).per(per_page)
    else
      @accounts = Account.search {
        keywords params[:q]
        without current_user.account
        paginate :page => page, :per_page => per_page
      }.results
    end

    render partial: 'accounts/list', :locals => { :kind => params[:kind] } and return
  end

  def parent
    klass, id = params[:parent].split('_')
    klass = %w[afisha organization].include?(klass) ? klass : 'afisha'

    @parent = klass.classify.constantize.find(id)
  end
end

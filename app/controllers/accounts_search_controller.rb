class AccountsSearchController < ApplicationController
  helper_method :kind, :category, :parent

  layout false

  def show
    page = params[:page] || 1
    per_page = 5

    @accounts = Account.search {
      keywords params[:q]
      with(:friend_ids, current_user.account.id) if params[:only_friends]
      with(Account.find(params[:account_id])) if params[:account_id]
      paginate :page => page, :per_page => per_page
    }.results

    render :partial => 'results', :locals => { :accounts => @accounts } and return if params[:only_results]
  end

  private

  def kind
    @kind = params[:kind]
  end

  def category
    @category = params[:category]
  end

  def parent
    return nil if params[:parent].blank?

    klass, id = params[:parent].split('_')
    klass = %w[afisha organization].include?(klass) ? klass : 'afisha'

    @parent = klass.classify.constantize.find(id)
  end
end

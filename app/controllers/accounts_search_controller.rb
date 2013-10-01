class AccountsSearchController < ApplicationController
  helper_method :kind, :category, :parent

  layout false

  def show
    @accounts = Account.search {
      keywords params[:q]
      paginate :page => params[:page] || 1, :per_page => 5
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

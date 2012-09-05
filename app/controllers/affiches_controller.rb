# encoding: utf-8

class AffichesController < ApplicationController
  inherit_resources

  actions :index, :show

  has_scope :page, :default => 1

  layout 'public'

  def index
    if request.xhr?
      @affiche_today = AfficheToday.new(params[:kind])
      render :partial => 'affiche_today', :layout => false and return
    else
      @affiche_collection = AfficheCollection.new(params)
    end
  end

  protected
    def collection
      @collection ||= search_results
    end

    def search_results
      search_params = params[:search] || {}
      search_params.reverse_merge!(:starts_on_greater_than => Date.today, :starts_on_less_than => (Date.today + 6.days).end_of_day)

      @affiches_hash = HasSearcher.searcher(:showing, search_params).limit(2_000).order_by(:starts_at).results.group_by(&:affiche)

      @affiches_hash.each do |affiche, showings|
        @affiches_hash[affiche] = showings.group_by(&:starts_on)
      end

      @affiches_hash.keys[((page - 1) * per_page)...(page * per_page)]
    end
end

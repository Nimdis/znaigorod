class Manage::AffichesController < Manage::ApplicationController
  actions :index, :new

  has_scope :page, :default => 1
  has_scope :by_state, :only => :index

  def index
    @affiches = apply_scopes(Affiche).page(params[:page], :per_page => per_page)
  end

  protected

  def collection
    params[:include_gone] ? include_gone : only_actual
  end

  def only_actual
    showing_ids = HasSearcher.searcher(:showing, params[:search]).limit(1000).result_ids

    Affiche.search {
      keywords(params[:q])
      paginate(paginate_options.merge(:per_page => per_page))

      adjust_solr_params do |params|
        params[:sort] = 'recip(abs(ms(NOW,first_showing_time_dt)),3.16e-11,1,1) desc'
      end

    }.results
  end

  def include_gone
    @search ||= Sunspot.search(Affiche) do
      keywords(params[:q])
      paginate(:page => params[:page], :per_page => per_page)
    end

    @search.results
  end
end

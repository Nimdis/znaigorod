class Manage::AffichesController < Manage::ApplicationController
  actions :index, :new

  custom_actions :resource => :fire_state_event

  has_scope :page, :default => 1
  has_scope :by_state, :only => :index

  def fire_state_event
    fire_state_event! {
      @affiche.fire_state_event params[:event] if @affiche.state_events.include?(params[:event].to_sym)

      redirect_to send("manage_#{@affiche.class.name.underscore}_path", @affiche) and return
    }
  end

  protected

  def collection
    @affiches = params[:include_gone] ? include_gone : only_actual
  end

  def only_actual
    Affiche.search {
      keywords params[:q]
      with :state, params[:by_state] if params[:by_state].present?
      paginate paginate_options.merge(:per_page => per_page)

      adjust_solr_params do |params|
        params[:sort] = 'recip(abs(ms(NOW,first_showing_time_dt)),3.16e-11,1,1) desc'
      end

    }.results
  end

  def include_gone
    Affiche.search {
      keywords params[:q]
      with :state, params[:by_state] if params[:by_state].present?
      paginate :page => params[:page], :per_page => per_page
    }.results
  end
end

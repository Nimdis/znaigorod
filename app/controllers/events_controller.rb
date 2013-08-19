class EventsController < ApplicationController
  inherit_resources

  belongs_to :account

  layout false

  def index
    index! {
      render partial: 'events/account_events', locals: { events: @events, :state => params[:by_state] }, layout: false and return
    }
  end

  private

  def collection
    @events = super.by_state(params[:by_state]).page(params[:page]).per(3)
  end
end

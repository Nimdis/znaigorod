class Manage::TicketInfosController < Manage::ApplicationController
  actions :index, :new, :create

  belongs_to :affiche, optional: true

  has_scope :by_state

  has_scope :page, :default => 1 do |controller, scope, value|
    scope.page(value).per(10)
  end

  def index
    if params[:utf8]
      @ticket_infos = TicketInfo.search {
        keywords params[:q]
        paginate(:page => params[:page] || 1, :per_page => 19)
      }.results
    else
      @ticket_infos = apply_scopes(TicketInfo)
    end
  end

  def create
    create! { parent_path }
  end
end

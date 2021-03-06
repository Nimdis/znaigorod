class Manage::CulturesController < Manage::ApplicationController
  defaults :singleton => true

  actions :all, :except => :show

  belongs_to :organization, :optional => true

  def index
    @collection = Culture.page(params[:page] || 1).per(10)
  end
end

class Manage::MealsController < Manage::ApplicationController
  defaults :singleton => true

  actions :all, :except => :show

  belongs_to :organization, :optional => true

  before_filter :redirect_to_edit, :only => :new, :if => :meal_exists?

  def index
    @collection = Meal.page(params[:page] || 1).per(10)
  end

  private

  def redirect_to_edit
    redirect_to edit_manage_organization_meal_path(parent) and return
  end

  def meal_exists?
    parent.meal
  end
end

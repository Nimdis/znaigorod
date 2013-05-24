class My::AffichesController < My::ApplicationController
  load_and_authorize_resource
  before_filter :current_step, only: [:edit]

  def create
    if Affiche.descendants.map(&:name).map(&:underscore).include?(params[:type])
      @affiche = params[:type].classify.constantize.new
      @affiche.state = :draft
      @affiche.save :validate => false

      redirect_to  edit_step_my_affiche_path(@affiche, :step => :first)
    else
      redirect_to new_my_affiche_path
    end
  end

  def update
    update! { edit_step_my_affiche_path(@affiche, :step => next_step) }
  end

  private

  def before_edit
    current_step
  end

  def current_step
    @step ||= Affiche.steps.include?(params[:step]) ? params[:step] : 'first'
  end

  def next_step
    begin
      Affiche.steps[Affiche.steps.index(current_step) + 1]
    rescue
      Affiche.steps.last
    end
  end
end

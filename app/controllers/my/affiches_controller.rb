class My::AffichesController < My::ApplicationController
  load_and_authorize_resource

  before_filter :current_step

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
    @affiche = Affiche.find(params[:id])
    @affiche.attributes = params[:affiche]

    if @affiche.save
      redirect_to edit_step_my_affiche_path(@affiche, :step => next_step)
    else
      render :edit
    end
  end

  private

  def before_edit
    current_step
  end

  def current_step
    @step ||= Affiche.steps.include?(params[:step]) ? params[:step] : 'first'
  end

  def next_step
    Affiche.steps[Affiche.steps.index(current_step) + 1] || Affiche.steps.last
  end
end

class My::AffichesController < My::ApplicationController
  def new
    @affiche = Affiche.new
  end

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

  def edit
    @step = Affiche.steps.include?(params[:step]) ? params[:step] : 'first'
    @affiche = Affiche.draft.find(params[:id])
  end

  def update
  end
end

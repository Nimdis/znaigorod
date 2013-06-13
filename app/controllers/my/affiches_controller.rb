#encoding: utf-8

class My::AffichesController < My::ApplicationController
  load_and_authorize_resource

  before_filter :current_step

  custom_actions :resource => :destroy_image

  def show
    @affiche = AfficheDecorator.new Affiche.find(params[:id])
  end

  def create
    if Affiche.descendants.map(&:name).map(&:underscore).include?(params[:type])
      affiche = params[:type].classify.constantize.new
      affiche.state = :draft
      affiche.user = current_user
      affiche.save :validate => false
      @affiche = AfficheDecorator.new affiche

      redirect_to my_affiche_path(@affiche)
    else
      redirect_to new_my_affiche_path
    end
  end

  def edit
    @affiche = current_user.affiches.available_for_edit.find(params[:id])
  end

  def update
    @affiche = current_user.affiches.available_for_edit.find(params[:id])
    @affiche.step = @step
    @affiche.attributes = params[:affiche]

    if @affiche.save
      redirect_to my_affiche_path(@affiche.id)
    else
      render :edit
    end
  end

  def available_tags
    query = params[:term]
    result = Affiche.pluck(:tag).compact.flat_map { |str| str.split(',') }.compact.map(&:squish).uniq.delete_if(&:blank?).select { |str| str =~ /^#{query}/ }.sort
    render text: result
  end

  def destroy_image
    @affiche.poster_url = nil
    @affiche.poster_image.destroy
    @affiche.save
    redirect_to edit_step_my_affiche_path(@affiche.id, :step => :second)
  end

  def send_to_moderation
    @affiche = current_user.affiches.available_for_edit.find(params[:affiche_id])
    @affiche.update_attributes!(:state => 'pending')

    MyMailer.delay.mail_new_pending_affiche(@affiche)
    redirect_to my_root_path, :notice => "Афиша «#{@affiche.title}» добавлена в очередь на модерацию."
  end

  private

  def before_edit
    current_step
  end

  def current_step
    @step ||= Affiche.steps.include?(params[:step]) ? params[:step] : Affiche.steps.first
  end

  def next_step
    return @step if @affiche.second_step? && !@affiche.set_region?

    Affiche.steps[Affiche.steps.index(current_step) + 1] || Affiche.steps.last
  end
end

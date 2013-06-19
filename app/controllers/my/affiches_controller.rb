#encoding: utf-8

class My::AffichesController < My::ApplicationController

  before_filter :current_step

  actions :all
  custom_actions :resource => [:destroy_image, :send_to_moderation, :send_to_published, :social_gallery], :collection => [:available_tags, :preview_video]

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
      if params[:crop]
        redirect_to edit_step_my_affiche_path(@affiche.id, :step => :second)
      else
        redirect_to my_affiche_path(@affiche.id)
      end
    else
      render :edit
    end
  end

  def available_tags
    @tags = Affiche.available_tags(params[:term])

    respond_to do |format|
      format.json { render text: @tags }
      format.html { render :select_tags }
    end
  end

  def preview_video
    code = params[:affiche].try(:[], :trailer_code)
    code.gsub!(/width=("|')(\d+)("|')/i, 'width="580"')
    code.gsub!(/height=("|')(\d+)("|')/i, 'height="350"')
    render text: Affiche.trailer_auto_html(code)
  end

  def destroy_image
    @affiche.poster_url = nil
    @affiche.poster_image.destroy
    @affiche.save
    redirect_to edit_step_my_affiche_path(@affiche.id, :step => :second)
  end

  def send_to_moderation
    @affiche = current_user.affiches.available_for_edit.find(params[:id])
    @affiche.send_to_moderation!

    MyMailer.delay.mail_new_pending_affiche(@affiche)
    redirect_to my_root_path, :notice => "Афиша «#{@affiche.title}» добавлена в очередь на модерацию."
  end

  def send_to_published
    @affiche = current_user.affiches.available_for_edit.find(params[:id])
    @affiche.approve!

    MyMailer.delay.mail_new_published_affiche(@affiche)
    redirect_to my_root_path, :notice => "Афиша «#{@affiche.title}» опубликована."
  end

  def social_gallery
    @affiche = current_user.affiches.available_for_edit.find(params[:id])
    gallery_url = params[:affiche][:social_gallery_url]
    case gallery_url
    when /yandex/
      url = gallery_url.match(/(?<=\/users\/).+\/album\/\d+/)
      @affiche.update_attributes :yandex_fotki_url => url.to_s if url.present?
    when /vk\.com/
      url = gallery_url.match(/(?<=\/album)-?\d+_\d+/).to_s.match(/\d+_\d+/)
      @affiche.update_attributes :vk_aid => url.to_s if url.present?
    end

    redirect_to edit_step_my_affiche_path(@affiche.id, :step => :fourth)
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

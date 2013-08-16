# encoding: utf-8

class My::AfishasController < My::ApplicationController

  defaults :resource_class => Afisha

  before_filter :current_step

  actions :all
  custom_actions :resource => [:destroy_image, :send_to_moderation, :send_to_published, :social_gallery], :collection => [:available_tags, :preview_video]

  def show
    @afisha = AfishaDecorator.new(current_user.afisha.find(params[:id]))
  end

  def create
    create! do |success, failure|
      success.html { redirect_to my_afisha_show_path(resource) }
    end
  end

  def edit
    @afisha = current_user.afisha.available_for_edit.find(params[:id])
  end

  def update
    @afisha = current_user.afisha.available_for_edit.find(params[:id])
    @afisha.step = @step
    @afisha.attributes = params[:afisha]

    if @afisha.save
      if params[:crop]
        redirect_to edit_step_my_afisha_path(@afisha.id, :step => :second)
      else
        redirect_to my_afisha_show_path(@afisha.id)
      end
    else
      render :edit
    end
  end

  def destroy
    destroy! { my_root_path }
  end

  def available_tags
    @tags = Afisha.available_tags(params[:term])

    respond_to do |format|
      format.json { render text: @tags }
      format.html { render :select_tags }
    end
  end

  def preview_video
    code = params[:afisha].try(:[], :trailer_code)
    code.gsub!(/width=("|')(\d+)("|')/i, 'width="580"')
    code.gsub!(/height=("|')(\d+)("|')/i, 'height="350"')
    render text: Afisha.trailer_auto_html(code)
  end

  def destroy_image
    @afisha = current_user.afisha.available_for_edit.find(params[:id])
    @afisha.poster_url = nil
    @afisha.poster_image.destroy
    @afisha.poster_image_url = nil
    @afisha.save
    redirect_to edit_step_my_afisha_path(@afisha.id, :step => :second)
  end

  def send_to_moderation
    @afisha = current_user.afisha.available_for_edit.find(params[:id])
    @afisha.send_to_moderation!

    redirect_to my_root_path, :notice => "Афиша «#{@afisha.title}» добавлена в очередь на модерацию."
  end

  def send_to_published
    @afisha = current_user.afisha.available_for_edit.find(params[:id])
    @afisha.approve!

    redirect_to my_root_path, :notice => "Афиша «#{@afisha.title}» опубликована."
  end

  def social_gallery
    @afisha = current_user.afisha.available_for_edit.find(params[:id])
    gallery_url = params[:afisha][:social_gallery_url]
    case gallery_url
    when /yandex/
      url = gallery_url.match(/(?<=\/users\/).+\/album\/\d+/)
      @afisha.update_attributes :yandex_fotki_url => url.to_s if url.present?
    when /vk\.com/
      url = gallery_url.match(/(?<=\/album)-?\d+_\d+/).to_s.match(/\d+_\d+/)
      @afisha.update_attributes :vk_aid => url.to_s if url.present?
    end

    redirect_to edit_step_my_afisha_path(@afisha.id, :step => :fourth)
  end

  private

  alias_method :old_build_resource, :build_resource

  def build_resource
    old_build_resource.tap do |object|
      object.user = current_user
    end
  end

  def current_step
    @step ||= Afisha.steps.include?(params[:step]) ? params[:step] : Afisha.steps.first
  end

  def next_step
    return @step if @afisha.second_step? && !@afisha.set_region?

    Afisha.steps[Afisha.steps.index(current_step) + 1] || Afisha.steps.last
  end
end

class My::GallerySocialImagesController < My::ApplicationController
  load_and_authorize_resource
  actions :destroy
  custom_actions :collection => :destroy_all

  belongs_to :afisha, :polymorphic => true, :optional => true

  def destroy
    destroy! {
      render :nothing => true and return
    }
  end

  def destroy_all
    destroy_all! {
      @afisha.gallery_social_images.destroy_all
      @afisha.update_attributes :vk_aid => nil, :yandex_fotki_url => nil
      redirect_to edit_step_my_afisha_path(@afisha.id, :step => :fourth) and return
    }
  end
end

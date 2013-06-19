class My::GallerySocialImagesController < My::ApplicationController
  actions :destroy
  custom_actions :collection => :destroy_all

  belongs_to :affiche, :polymorphic => true, :optional => true

  def destroy
    destroy! {
      render :nothing => true and return
    }
  end

  def destroy_all
    destroy_all! {
      @affiche.gallery_social_images.destroy_all
      @affiche.update_attributes :vk_aid => nil, :yandex_fotki_url => nil
      redirect_to edit_step_my_affiche_path(@affiche.id, :step => :fourth) and return
    }
  end
end

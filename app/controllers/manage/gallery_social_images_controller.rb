class Manage::GallerySocialImagesController < Manage::ApplicationController
  actions :new, :create, :destroy, :update, :edit
  custom_actions :collection => :destroy_all

  belongs_to :afisha, :polymorphic => true, :optional => true

  def create
    create! { collection_path }
  end

  def update
    update! { collection_path }
  end

  def destroy
    destroy! {
      render :nothing => true and return
    }
  end

  def destroy_all
    destroy_all! {
      parent.gallery_social_images.destroy_all
      parent.update_attributes :vk_aid => nil, :yandex_fotki_url => nil
      redirect_to collection_path and return
    }
  end

  protected
    def collection_path
      manage_afisha_show_path(parent)
    end
end

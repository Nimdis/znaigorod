class Manage::GallerySocialImagesController < Manage::ApplicationController
  actions :new, :create, :destroy, :update, :edit
  custom_actions :collection => :destroy_all

  Affiche.descendants.each do |type|
    belongs_to type.name.underscore, :polymorphic => true, :optional => :true
  end
  belongs_to :affiche, :polymorphic => true, :optional => true

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
      redirect_to collection_path and return
    }
  end

  protected
    def collection_path
      manage_affiche_path(parent)
    end
end

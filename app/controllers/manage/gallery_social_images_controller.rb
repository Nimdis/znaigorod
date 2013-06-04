class Manage::GallerySocialImagesController < Manage::ApplicationController
  actions :new, :create, :destroy, :update, :edit

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

  protected
    def collection_path
      manage_affiche_path(parent)
    end
end

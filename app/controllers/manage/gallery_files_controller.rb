class Manage::GalleryFilesController < Manage::ApplicationController
  actions :new, :create, :destroy, :update, :edit

  belongs_to :affiche, :organization, :polymorphic => true, :optional => true

  def create
    create! do
      is_parent_affiche? ? manage_affiche_path(parent) : manage_organization_path(parent)
    end
  end

  def destroy
    destroy! do
      is_parent_affiche? ? manage_affiche_path(parent) : manage_organization_path(parent)
    end
  end

  protected
    def collection_path
      is_parent_affiche? ? manage_affiche_attachments_path(parent) : manage_organization_attachments_path(parent)
    end

    def is_parent_affiche?
      parent.class.superclass.name.underscore == 'affiche'
    end
end

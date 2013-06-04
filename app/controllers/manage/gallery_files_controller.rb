class Manage::GalleryFilesController < Manage::ApplicationController
  actions :new, :create, :destroy, :update, :edit
  custom_actions :resource => :destroy_file

  belongs_to *Organization.available_suborganization_kinds,
    :polymorphic => true, :optional => true

  Affiche.descendants.each do |type|
    belongs_to type.name.underscore, :polymorphic => true, :optional => :true
  end

  belongs_to :affiche, :organization, :polymorphic => true, :optional => true

  def create
    @parent = parent.class.find(params[(parent.class.superclass.name.underscore + '_id').to_sym])
    @gallery_file = @parent.gallery_files.create(:file => params[:gallery_files][:file].first)
  end

  def update
    update! { collection_path }
  end

  def destroy
    destroy! do
      is_parent_affiche? ? manage_affiche_path(parent) : manage_organization_path(parent)
    end
  end

  def destroy_file
    @gallery_file.file.destroy
    redirect_to [:edit, :manage, parent, @gallery_file]
  end

  protected
    def collection_path
      is_parent_affiche? ? manage_affiche_path(parent) : manage_organization_path(parent)
    end

    def is_parent_affiche?
      parent.class.superclass.name.underscore == 'affiche'
    end
end

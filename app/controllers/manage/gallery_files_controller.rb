class Manage::GalleryFilesController < Manage::ApplicationController
  actions :new, :create, :destroy, :update, :edit
  custom_actions :resource => :destroy_file

  belongs_to *Organization.available_suborganization_kinds,
    :polymorphic => true, :optional => true

  belongs_to :afisha, :organization, :polymorphic => true, :optional => true

  def create
    @gallery_file = parent.gallery_files.create(:file => params[:gallery_files][:file])
  end

  def update
    update! { collection_path }
  end

  def destroy
    destroy! {
      render :nothing => true and return
    }
  end

  def destroy_file
    @gallery_file.file.destroy
    redirect_to [:edit, :manage, parent, @gallery_file]
  end

  protected
    def collection_path
      case parent
      when Afisha
        manage_afisha_show_path(parent)
      when Organization
        manage_organization_path(parent)
      when *Organization.available_suborganization_classes
        manage_organization_path(parent.organization)
      end
    end
end

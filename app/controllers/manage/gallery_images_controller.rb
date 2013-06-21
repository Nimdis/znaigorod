class Manage::GalleryImagesController < Manage::ApplicationController
  actions :new, :create, :destroy, :update, :edit
  custom_actions :resource => :destroy_file

  belongs_to *Organization.available_suborganization_kinds,
    :polymorphic => true, :optional => true

  Affiche.descendants.each do |type|
    belongs_to type.name.underscore, :polymorphic => true, :optional => :true
  end

  belongs_to :affiche, :organization, :sauna_hall, :polymorphic => true, :optional => true

  def create
    @parent = parent.class.find(params[(parent.class.superclass.name == 'Affiche' ? parent.class.superclass.name.underscore : parent.class.name.underscore) + '_id'])
    @gallery_image = @parent.gallery_images.create(:file => params[:gallery_images][:file].first)
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
    @gallery_image.file.destroy
    redirect_to [:edit, :manage, parent, @gallery_image]
  end

  protected
    def collection_path
      case parent
      when Affiche
        manage_affiche_path(parent)
      when Organization
        manage_organization_path(parent)
      when SaunaHall
        manage_organization_sauna_sauna_hall_path(@organization, parent)
      when *Organization.available_suborganization_classes
        manage_organization_path(parent.organization)
      end
    end
end
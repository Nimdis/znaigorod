class My::GalleryImagesController < My::ApplicationController
  actions :show, :create, :destroy

  belongs_to :affiche, :polymorphic => true, :optional => true

  def create
    @affiche = Affiche.find(params[:affiche_id])
    @gallery_image = @affiche.gallery_images.create(:file => params[:gallery_image][:file].first)
  end

  def destroy
    destroy! { edit_step_my_affiche_path(@affiche.id, :step => :fourth) }
  end
end

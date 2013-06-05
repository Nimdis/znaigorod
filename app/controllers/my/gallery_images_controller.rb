class My::GalleryImagesController < My::ApplicationController
  actions :show, :create, :destroy

  belongs_to :affiche, :polymorphic => true, :optional => true

  def create
    @affiche = Affiche.find(params[:affiche_id])
    @gallery_image = @affiche.gallery_images.create(:file => params[:gallery_images][:file].first)
  end

  def destroy
    destroy! {
      render :nothing => true and return
    }
  end
end

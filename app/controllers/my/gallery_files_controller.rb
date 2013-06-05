class My::GalleryFilesController < My::ApplicationController
  actions :show, :create, :destroy

  belongs_to :affiche, :polymorphic => true, :optional => true

  def create
    @affiche = Affiche.find(params[:affiche_id])
    @gallery_file = @affiche.gallery_files.create(:file => params[:gallery_files][:file].first)
  end

  def destroy
    destroy! {
      render :nothing => true and return
    }
  end
end

class My::GalleryFilesController < My::ApplicationController
  actions :show, :create, :destroy

  belongs_to :affiche, :polymorphic => true, :optional => true

  def create
    @affiche = Affiche.find(params[:affiche_id])
    @gallery_file = @affiche.gallery_files.create(:file => params[:gallery_file][:file].first)
  end

  def destroy
    destroy! { edit_step_my_affiche_path(@affiche.id, :step => :fourth) }
  end
end

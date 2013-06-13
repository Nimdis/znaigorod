class My::GalleryFilesController < My::ApplicationController
  actions :create, :destroy
  custom_actions :collection => :destroy_all

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

  def destroy_all
    destroy_all! {
      @affiche.gallery_files.destroy_all
      redirect_to edit_step_my_affiche_path(@affiche.id, :step => :fourth) and return
    }
  end
end

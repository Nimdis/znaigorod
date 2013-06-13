class My::GalleryImagesController < My::ApplicationController
  actions :create, :destroy
  custom_actions :collection => :destroy_all

  belongs_to :affiche, :polymorphic => true, :optional => true

  def create
    @affiche = current_user.affiches.available_for_edit.find(params[:affiche_id])
    @gallery_image = @affiche.gallery_images.create(:file => params[:gallery_images][:file].first)
  end

  def destroy
    destroy! {
      render :nothing => true and return
    }
  end

  def destroy_all
    destroy_all! {
      @affiche = current_user.affiches.available_for_edit.find(params[:affiche_id])
      @affiche.gallery_images.destroy_all
      redirect_to edit_step_my_affiche_path(@affiche.id, :step => :fourth) and return
    }
  end
end

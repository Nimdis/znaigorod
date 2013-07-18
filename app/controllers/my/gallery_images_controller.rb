class My::GalleryImagesController < My::ApplicationController
  actions :create, :destroy
  custom_actions :collection => :destroy_all

  belongs_to :afisha, :polymorphic => true, :optional => true

  def create
    @afisha = current_user.afisha.available_for_edit.find(params[:afisha_id])
    @gallery_image = @afisha.gallery_images.create(:file => params[:gallery_images][:file].first)
  end

  def destroy
    destroy! {
      render :nothing => true and return
    }
  end

  def destroy_all
    destroy_all! {
      @afisha = current_user.afisha.available_for_edit.find(params[:afisha_id])
      @afisha.gallery_images.destroy_all
      redirect_to edit_step_my_afisha_path(@afisha.id, :step => :fourth) and return
    }
  end
end

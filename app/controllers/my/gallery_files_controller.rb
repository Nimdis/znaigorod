class My::GalleryFilesController < My::ApplicationController
  actions :create, :destroy
  custom_actions :collection => :destroy_all

  belongs_to :afisha, :polymorphic => true, :optional => true

  def create
    @afisha = Afisha.find(params[:afisha_id])
    @gallery_file = @afisha.gallery_files.create(:file => params[:gallery_files][:file].first)
  end

  def destroy
    destroy! {
      render :nothing => true and return
    }
  end

  def destroy_all
    destroy_all! {
      @afisha.gallery_files.destroy_all
      redirect_to edit_step_my_afisha_path(@afisha.id, :step => :sixth) and return
    }
  end
end

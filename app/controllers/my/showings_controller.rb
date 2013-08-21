# encoding: utf-8

class My::ShowingsController < My::ApplicationController
  load_and_authorize_resource

  actions :new, :create, :destroy, :edit, :update

  belongs_to :afisha

  def create
    create! { redirect_to my_afisha_path(@afisha) and return }
  end

  def destroy
    destroy! { redirect_to my_afisha_path(@afisha) and return }
  end

  def update
    update! { redirect_to my_afisha_path(@afisha) and return }
  end
end

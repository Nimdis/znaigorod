# encoding: utf-8

class My::ShowingsController < My::ApplicationController
  inherit_resources

  actions :new, :create, :destroy, :edit, :update

  belongs_to :affiche

  def create
    create! { redirect_to my_affiche_path(@affiche) and return }
  end

  def destroy
    destroy! { redirect_to my_affiche_path(@affiche) and return }
  end

  def update
    update! { redirect_to my_affiche_path(@affiche) and return }
  end
end

class Manage::MenusController < Manage::ApplicationController
  actions :all, :except => [:index, :show]

  belongs_to :organization do
    belongs_to :meal, singleton: true
  end

  def destroy
    destroy! { request.referer }
  end

  def create
    create! { parent_url }
  end
end

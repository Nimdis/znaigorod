class Manage::MenusController < Manage::ApplicationController

  actions :all, :except => [:index, :show]

  belongs_to :organization do
    belongs_to :meal, singleton: true
  end

  def smart_collection_url
    [:manage, @organization, :meal]
  end

  def update
    params[:menu][:menu_positions_attributes].each_with_index do |attr, index|
      menu_positions_attributes = attr[1]
      if menu_positions_attributes[:delete_image]
        MenuPosition.find(menu_positions_attributes[:id]).image_destroy
      end
    end
    update!
  end

end

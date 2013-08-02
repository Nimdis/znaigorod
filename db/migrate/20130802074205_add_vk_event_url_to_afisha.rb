class AddVkEventUrlToAfisha < ActiveRecord::Migration
  def change
    add_column :afisha, :vk_event_url, :string
  end
end

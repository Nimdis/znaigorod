class AddMessageToSmses < ActiveRecord::Migration
  def change
    add_column :smses, :message, :text
  end
end

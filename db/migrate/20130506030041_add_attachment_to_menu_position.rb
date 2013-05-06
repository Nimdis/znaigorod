class AddAttachmentToMenuPosition < ActiveRecord::Migration
  def change
    add_column :menu_positions, :image_file_name, :string
    add_column :menu_positions, :image_content_type, :string
    add_column :menu_positions, :image_file_size, :integer
    add_column :menu_positions, :image_updated_at, :datetime
    add_column :menu_positions, :image_url, :text
  end
end

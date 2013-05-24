class AddPosterToAffiches < ActiveRecord::Migration
  def change
    add_column :affiches, :poster_image_file_name, :string
    add_column :affiches, :poster_image_content_type, :string
    add_column :affiches, :poster_image_file_size, :integer
    add_column :affiches, :poster_image_updated_at, :datetime
    add_column :affiches, :poster_image_url, :text
  end
end

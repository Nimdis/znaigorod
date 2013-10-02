class AddSnapshotUrlToWebcams < ActiveRecord::Migration
  def change
    add_column :webcams, :snapshot_url, :text
    add_column :webcams, :snapshot_image_file_name, :string
    add_column :webcams, :snapshot_image_content_type, :string
    add_column :webcams, :snapshot_image_file_size, :integer
    add_column :webcams, :snapshot_image_updated_at, :datetime
    add_column :webcams, :snapshot_image_url, :text
  end
end

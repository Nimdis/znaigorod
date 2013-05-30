class ChangeAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :type, :string
    add_column :attachments, :thumbnail_url, :text
    add_column :attachments, :height, :integer
    add_column :attachments, :width, :integer
    add_attachment :attachments, :file

    pg = ProgressBar.new(Attachment.all.count)
    Attachment.all.each do |a|
      a.update_column :type, 'GalleryFile'
      a.update_column :file_url, a.url
      a.update_column :file_file_name, a.url.split('/').last
      a.update_column :file_updated_at, Time.zone.now
      pg.increment!
    end

    our_images = Image.where('thumbnail_url IS NULL')
    pg = ProgressBar.new(our_images.count)
    our_images.each do |image|
      gi = GalleryImage.new(:description => image.description)
      gi.attachable_id = image.imageable_id
      gi.attachable_type = image.imageable_type
      gi.save(:validate => false)
      gi.update_column :file_url, image.url
      gi.update_column :file_file_name, image.url.split('/').last
      gi.update_column :file_updated_at, image.updated_at
      gi.update_column :file_content_type, 'image/jpg'
      image.delete
      pg.increment!
    end

    social_images = Image.where('thumbnail_url IS NOT NULL')
    pg = ProgressBar.new(social_images.count)
    social_images.each do |image|
      gi = GalleryImage.new(:description => image.description)
      gi.attachable_id = image.imageable_id
      gi.attachable_type = image.imageable_type
      gi.save(:validate => false)
      gi.update_column :file_url, image.url
      gi.update_column :thumbnail_url, image.thumbnail_url
      image.delete
      pg.increment!
    end

    remove_column :attachments, :url
    drop_table :images
  end
end

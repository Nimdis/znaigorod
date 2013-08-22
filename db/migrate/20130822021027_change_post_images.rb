class Post < ActiveRecord::Base
  has_many :post_images
end

class PostImage < ActiveRecord::Base
  belongs_to :post
end

class ChangePostImages < ActiveRecord::Migration
  def change
    post_images = PostImage.all
    pg = ProgressBar.new(post_images.count)
    post_images.each do |image|
      gi = GalleryImage.new(:description => image.post.title || '')
      gi.attachable_id = image.post_id
      gi.attachable_type = 'Post'
      gi.save(:validate => false)
      gi.update_column :file_url, image.attachment_url
      gi.update_column :file_file_name, image.attachment_url.split('/').last
      gi.update_column :file_updated_at, image.updated_at
      gi.update_column :file_content_type, 'image/jpg'
      image.delete
      pg.increment!
    end

    drop_table :post_images
  end
end

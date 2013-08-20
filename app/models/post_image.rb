# encoding: utf-8

class PostImage < ActiveRecord::Base
  belongs_to :post
  attr_accessible :title, :attachment

  has_attached_file :attachment, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  def partial_for_render_object
    "#{self.class.name.underscore.pluralize}/#{self.class.name.underscore}"
  end
end

# == Schema Information
#
# Table name: post_images
#
#  id                      :integer          not null, primary key
#  title                   :string(255)
#  post_id                 :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  attachment_url          :text
#


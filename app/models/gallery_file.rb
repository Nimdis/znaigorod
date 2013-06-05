# encoding: utf-8

class GalleryFile < Attachment
  has_attached_file :file, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  validates_attachment :file, :presence => true
end

# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  attachable_id   :integer
#  attachable_type :string(255)
#  url             :string(255)
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#


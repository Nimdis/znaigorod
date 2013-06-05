# encoding: utf-8

class GalleryImage < Attachment
  has_attached_file :file, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  validates_attachment :file, :presence => true, :content_type => {
    :content_type => ['image/jpeg', 'image/jpg', 'image/png'],
    :message => 'Изображение должно быть в формате jpeg, jpg или png' }
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


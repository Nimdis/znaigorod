class GalleryImage < Attachment
  has_attached_file :file, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  validates_attachment :file, :presence => true, :content_type => {
    :content_type => ['image/jpeg', 'image/jpg', 'image/png'],
    :message => 'Изображение должно быть в формате jpeg, jpg или png' }
end

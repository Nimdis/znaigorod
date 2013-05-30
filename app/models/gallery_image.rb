class GalleryImage < Attachment
  has_attached_file :file, :storage => :elvfs, :elvfs_url => Settings['storage.url']
end

class GalleryFile < Attachment
  has_attached_file :file, :storage => :elvfs, :elvfs_url => Settings['storage.url']
end

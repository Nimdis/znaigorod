# encoding: utf-8

module VkUpload
  extend ActiveSupport::Concern

  def vk_client
    VkontakteApi::Client.new(User.find(9).token)
  end

  def album_title
    if self.is_a?(Afisha)
      "Афиши #{I18n.l(Time.zone.today, :format => '%B-%Y')}"
    elsif self.is_a?(Organization)
      "Организации"
    end
  end

  def vk_album_id(client)
    album_id = nil
    album = client.photos.get_albums(owner_id: "-#{Settings[:vk][:group_id]}").select{|g| g.title == album_title}

    if album.one?
      album_id = album.first.aid
    else
      album_id = create_vk_album(client)
    end

    album_id
  end

  def create_vk_album(client)
    album = client.photos.create_album(title: album_title, group_id: Settings[:vk][:group_id], comment_privacy: 1, privacy: 1)
    album.aid
  end

  def image_url
    if self.is_a?(Afisha)
      poster_url
    elsif self.is_a?(Organization)
      logotype_url
    end
  end

  def upload_poster_to_vk
    client = vk_client
    begin
      album_id = vk_album_id(client)
      up_serv = client.photos.get_upload_server(aid: album_id, group_id: Settings[:vk][:group_id])
      file = Tempfile.new([self.slug,'.jpg'])
      file.binmode
      file.write open(image_url).read
      upload = VkontakteApi.upload(url: up_serv.upload_url, photo: [file.path, 'image/jpeg'])
      photo = client.photos.save(upload)
      file.close!
      photo_vk_id = "photo#{photo.first.owner_id}_#{photo.first.pid}"
      self.update_column(:poster_vk_id, photo_vk_id)
      client.photos.edit(oid: photo.first.owner_id, photo_id: photo.first.pid, caption: self.title)
    rescue VkontakteApi::Error => e
    end
  end
end

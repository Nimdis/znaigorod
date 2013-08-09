class SocialLikes

  def initialize
    @vk_client = VkontakteApi::Client.new
  end

  def url(item)
    URI.escape("#{Settings[:app][:url]}/#{item.class.name.underscore}/#{item.slug}")
  end

  def vkontakte_likes(item)
    if item.slug?
      begin
        @vk_client.likes.get_list(type: 'sitepage', owner_id: '3136085', page_url: url(item))['count']
      rescue VkontakteApi::Error => e 
        return
      end
    end
  end

  def fb_likes(item)
    if item.slug?
      data = open("http://graph.facebook.com/?ids=#{url(item)}").read
      data = JSON.parse(data)
      data[url(item)]['shares']
    end
  end

  def odn_likes(item)
    if item.slug?
      begin
        data = open("http://www.odnoklassniki.ru/dk?st.cmd=shareData&cb=mailru.share.ok.init&ref=#{url(item)}").read
        JSON.parse(data.match('\{.+\}').to_s)['count'].to_i
      rescue
        return
      end
    end
  end
end

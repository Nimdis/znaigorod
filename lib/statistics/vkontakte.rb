require 'vkontakte_api'

module Statistics
  VkontakteApi.log_errors = false
  VkontakteApi.log_requests = false

  class Vkontakte
    def update_statistics
      update_afisha
      update_organizations
    end

    private

    def vk_client
      @vk_client ||= VkontakteApi::Client.new
    end

    def type
      'sitepage'
    end

    def owner_id
      '3136085'
    end

    def likes_for(page_url)
      begin
        return vk_client.likes.get_list(type: type, owner_id: owner_id, page_url: page_url)['count']
      rescue VkontakteApi::Error => e
        return 0
      end
    end

    def yandex_statistics
      @yandex_statistics ||= Yandex.new
    end

    delegate :afisha_urls, :organization_urls, to: :yandex_statistics

    def update_afisha
      puts 'Updating afisha...'
      pb = ProgressBar.new(afisha_urls.size)

      afisha_urls.each do |url|
        pb.increment!
        slug = url.split('/').last

        if afisha = Afisha.find_by_slug(slug)
          afisha.update_attribute :vkontakte_likes, likes_for(url)
        end
      end
    end

    def update_organizations
      puts 'Updating organizations...'
      pb = ProgressBar.new(organization_urls.size)

      organization_urls.each do |url|
        pb.increment!
        slug = url.split('/').last

        if organization = Organization.find_by_slug(slug)
          organization.update_attribute :vkontakte_likes, likes_for(url)
        end
      end
    end
  end
end

require 'curb'

module Statistics
  class Yandex
    def update_statistics
      update_afisha
      update_organizations
    end

    def afisha_urls
      afisha_items.sort_by { |item| item.page_views }.reverse.first(100).map(&:url)
    end

    def organization_urls
      organization_items.sort_by { |item| item.page_views }.reverse.first(100).map(&:url)
    end

    private

    def api_url
      'http://api-metrika.yandex.ru'
    end

    def method_name
      'stat/content/popular'
    end

    def results_format
      'json'
    end

    def oauth_token
      Settings['yandex.oauth_token']
    end

    def counter_id
      '14923525'
    end

    def per_page
      5000
    end

    def params
      CGI.unescape({ oauth_token: oauth_token, id: counter_id, per_page: per_page }.to_query)
    end

    def request_url
      "#{api_url}/#{method_name}.#{results_format}?#{params}"
    end

    def response
      Hashie::Mash.new JSON.parse(Curl.get(request_url).body_str)
    end

    def data
      @data ||= response.data
    end

    def afisha_items
      @afisha_items ||= data.select { |item| item.url =~ %r{(#{Afisha.kind.values.join('|')})/[^#/]+$} }
    end

    def organization_items
      @organization_items ||= data.select { |item| item.url =~ %r{organizations/[^#/]+$} }
    end

    def update_afisha
      puts 'Updating afisha...'
      pb = ProgressBar.new(afisha_items.size)

      afisha_items.each do |item|
        pb.increment!
        slug = item.url.split('/').last

        if afisha = Afisha.find_by_slug(slug)
          afisha.update_attribute :yandex_metrika_page_views, item.page_views
        end
      end
    end

    def update_organizations
      puts 'Updating organizations...'
      pb = ProgressBar.new(organization_items.size)

      organization_items.each do |item|
        pb.increment!
        slug = item.url.split('/').last

        if organization = Organization.find_by_slug(slug)
          organization.update_attribute :yandex_metrika_page_views, item.page_views
        end
      end
    end
  end
end

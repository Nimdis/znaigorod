# encoding: utf-8

require 'curb'

class YampGeocoder

  def self.get_coordinates(street, house)
    address = ["город Томск", "Томская область", street, house].join(', ')

    parameters = { geocode: address, format: :json, results: 1 }

    result = [nil, nil]

    c = Curl::Easy.new("http://geocode-maps.yandex.ru/1.x/?#{parameters.to_query}") do |curl|
      curl.on_success do |easy|
      response = JSON.parse(easy.body_str)['response']['GeoObjectCollection']['featureMember'].first['GeoObject']
      result = response['Point']['pos'].split(' ')
      returned_house = response['name'].split(', ').last
      if returned_house.squish.eql?(house.squish)
        result << '200'
      else
        result << '404'
      end
      result << response['name']
      result << response['description']
    end
    end

    begin
      c.perform if street.present?
    rescue
      return { response_code: 500 }
    end

    Hash[[:longitude, :latitude, :response_code, :name, :description].zip(result)]
  end

  def self.get_houses(query)
    result = {}
    unless query.empty?
      cache = call_cache query
      if cache.nil?
        address = ["Россия", "Томск", query].join(', ')
        coords = [84.94817, 56.490594].join(', ')
        parameters = {
          text: address,
          sll: coords,
          vrb: '1',
          perm: '1',
          source: 'houses',
          output: 'json'
        }
        address = ''
          c = Curl::Easy.new("http://maps.yandex.ru/?#{parameters.to_query}") do |curl|
            curl.on_success do |easy|
              result = JSON.parse(easy.body_str)
              result = result['vpage']['data']['locations']['GeoObjectCollection']['features'][0]['properties']['GeocoderMetaData']
              address = result['text']
              address = address.split(',')
              address.delete_at(0)
              address.delete_at(0)
              address = address.join(', ')
              if result['InternalToponymInfo']['houses'] != 0
                result = {
                  address: address,
                  houses: result['InternalToponymInfo']['Houses']
                }
              else
                geometry = result['InternalToponymInfo']['Point']
                name = result['AddressDetails']['Country']['AddressLine'].split(',').last()
                address =  result['AddressDetails']['Country']['AddressLine'].split(',')
                address.delete_at(0)
                address.delete_at(address.rindex(address.last))
                address = address.join(", ")
                result = {
                  address: address,
                  houses:[{
                    "name" => name,
                    "geometry" =>  geometry
                  }]
                }
              end

            end
          end
          begin
            c.perform if query.present?
          rescue
            return { response_code: 500 }
          end
        write_cache query, result
      else
        result = cache
      end
    end
    result
  end

  def self.call_cache key
    Rails.cache.read key
  end

  def self.write_cache key, obj
    Rails.cache.write key, obj, :expires_in => 1.day
  end

  def self.get_house_photo(coords)
    result = {}
    unless coords.empty?
      key = coords.gsub(',','').gsub('.','')
      cache = call_cache key
      if cache.nil?
        parameters = {
          lang: 'ru-RU',
          ll: coords,
          l: 'hph',
          results: '10',
          origin: 'maps-nav'
        }
        photos= []
        c = Curl::Easy.new("http://maps.yandex.ru/services/photos/1.x/photos.json?#{parameters.to_query}") do |curl|
          curl.on_success do |easy|
            result = JSON.parse(easy.body_str)
            result['entries'].each do |photo|
              photos.push photo['img']
            end
            result = photos
          end
        end
        begin
          c.perform if coords.present?
        rescue
          return { response_code: 500 }
        end
        write_cache key, result
      else
        result = cache
      end
    end
    result
  end

  def self.get_addresses(query)
    get_houses(query)
  end

end

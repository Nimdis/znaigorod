# encoding: utf-8

module ImageHelper

  def resized_image_url(url, width, height, options = { crop: '!', orientation: 'n' })
    if url.match(/\d+\/region\/\d+/)
      return url.gsub(/(\/region\/(\d+|\/){8})/) { "#{$1}#{width}-#{height}/" }
    end
    if url.match(/\/files\/\d+\/\d+-\d+\//)
      image_url, image_id, image_width, image_height, image_crop, image_filename = url.match(%r{(.*)/files/(\d+)/(?:(\d+)-(\d+)(\!)?/)?(.*)})[1..-1]
      return "#{image_url}/files/#{image_id}/#{width}-#{height}#{options[:crop]}#{options[:orientation]}/#{image_filename}"
    end
    url
  end

end
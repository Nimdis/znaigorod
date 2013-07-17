# encoding: utf-8

class PhotoreportDecorator < AfishaDecorator
  decorates :afisha

  def date
    h.l afisha.images.first.created_at, :format => '%e %B'
  end

  def link
    h.link_to afisha.title.to_s.text_gilensize.truncated(77), h.afisha_show_path(afisha, :anchor => 'photogallery'), :title => afisha.title
  end

  def main_images
    result = ""
    afisha.images.first(4).reverse.each do |image|
      if image.thumbnail_url?
        result += h.link_to h.image_tag(image.file_url, :height => 190, :title => image.description), h.afisha_show_path(afisha, :anchor => 'photogallery')
      else
        result += h.link_to image_tag(image.file_url, 220, 220, image.description, false), h.afisha_show_path(afisha, :anchor => 'photogallery')
      end
    end
    h.raw result
  end

  def images_count
    afisha.images.count
  end

end

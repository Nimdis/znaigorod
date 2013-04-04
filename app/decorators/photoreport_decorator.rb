# encoding: utf-8

class PhotoreportDecorator < AfficheDecorator
  decorates :affiche

  def date
    h.l affiche.images.first.created_at, :format => '%e %B'
  end

  def link
    h.link_to affiche.title.text_gilensize.truncated(77), kind_affiche_path(:anchor => 'photogallery'), :title => affiche.title
  end

  def main_images
    result = ""
    affiche.images.limit(4).reverse.each do |image|
      if image.thumbnail_url?
        result += h.link_to h.image_tag(image.url, :height => 190, :title => image.description), kind_affiche_path(:anchor => 'photogallery')
      else
        result += h.link_to image_tag(image.url, 220, 220, image.description, false), kind_affiche_path(:anchor => 'photogallery')
      end
    end
    h.raw result
  end

  def images_count
    affiche.images.count
  end

end

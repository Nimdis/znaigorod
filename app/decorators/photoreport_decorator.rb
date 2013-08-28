# encoding: utf-8

class PhotoreportDecorator < AfishaDecorator
  decorates :afisha

  def date
    h.l afisha.images.first.created_at, :format => '%e %B'
  end

  def link
    h.link_to afisha.title.to_s.text_gilensize.truncated(77), h.afisha_show_path(afisha, :anchor => 'photogallery'), :title => afisha.title
  end

  def images_count
    afisha.images.count
  end

end

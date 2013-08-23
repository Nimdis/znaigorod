# encoding: utf-8

class PostDecorator < ApplicationDecorator
  decorates :post

  def title
    post.title
  end

  def show_url
    h.post_url(post)
  end

  def annotation_image?
    return true if gallery_images.any?
  end

  def annotation_image(width, height)
    h.link_to h.post_path(post) do
      h.content_tag :div, h.image_tag(h.resized_image_url(gallery_images.first.file_url, width, height, { crop: '!', orientation: 'n' }), size: "#{width}x#{height}", alt: post.title.gilensize, title: post.title.gilensize), class: :image
    end
  end

  def date
    h.content_tag :div, Russian::strftime(post.created_at, "%d %B %Y"), class: :date
  end

  def html_content
    @html_content ||= content.to_s.as_html
  end
end

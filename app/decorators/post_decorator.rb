# encoding: utf-8

class PostDecorator < ApplicationDecorator
  decorates :post

  delegate :title, :html_content, to: :post

  def truncated_title_link(length, options = { separator: ' ', anchor: nil })
    if title.length > length
      h.link_to(title.text_gilensize.truncated(length, options[:separator]), h.post_path(post, anchor: options[:anchor]), :title => title)
    else
      h.link_to(title.text_gilensize, h.post_path(post, anchor: options[:anchor]))
    end
  end

  def truncated_description(length)
    Sanitize.clean(html_content).gsub('&nbsp;', '').truncated(length, ' ')
  end

  def show_url
    @show_url ||= h.post_url(post)
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
    h.content_tag :div, I18n.l(post.created_at, format: "%d %B %Y"), class: :date
  end

  def html_content
    @html_content ||= content.to_s.as_html
  end
end

# encoding: utf-8

class PostDecorator < ApplicationDecorator
  decorates :post

  def title
    post.title
  end

  def show_url
    h.post_url(post)
  end

  def image
    post.poster_url
  end

  def date
    Russian::strftime(post.created_at, "%d %B %Y")
  end

  def html_annotation
    @html_annotation ||= annotation.to_s.as_html
  end

  def html_content
    @html_content ||= content.to_s.as_html
  end
end

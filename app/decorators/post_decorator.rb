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

  def annotation
    post.annotation.html_safe
  end
end

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
end

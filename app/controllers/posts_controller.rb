class PostsController < ApplicationController
  inherit_resources
  actions :index, :show
  has_scope :page, :default => 1

  def index
    @presenter = PostPresenter.new(params)
    render partial: 'posts/post_posters', layout: false and return if request.xhr?
  end

  def draft
    @posts = Post.draft.page(params[:page]).per(params[:per_page] || 10)
  end

  def show
      @presenter = PostPresenter.new(params)
      @post = PostDecorator.new(Post.find(params[:id]))
      @posts = Post.published
  end

  private

  def collection
    HasSearcher.searcher(:posts, params).paginate(:page => params[:page], :per_page => per_page)
  end

  def per_page
    15
  end
end

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
    @post.delay.create_page_visit(request.session_options[:id], current_user)
  end

end

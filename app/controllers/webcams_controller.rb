class WebcamsController < ApplicationController

  inherit_resources

  actions :index, :show

  has_scope :published, :type => :boolean, :default => true
  has_scope :ordered, :default => 'title'

  def index
    @webcams = Webcam.ordered(:title).published
  end

  def show
    show! { render :layout => 'webcam' and return }
  end

end

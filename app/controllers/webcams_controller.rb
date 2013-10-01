class WebcamsController < ApplicationController

  inherit_resources

  actions :index, :show

  has_scope :published, :type => :boolean, :default => true
  has_scope :ordered, :default => 'title'

end

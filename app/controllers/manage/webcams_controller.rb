class Manage::WebcamsController < Manage::ApplicationController

  actions :all

  has_scope :ordered, :type => :boolean, :default => true

  after_filter :reset_cache, :only => [:create, :update]

  protected

  def reset_cache
    expire_page webcams_path if @webcam.errors.empty?
  end
end

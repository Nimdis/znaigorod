class Manage::WebcamsController < Manage::ApplicationController

  actions :all

  has_scope :ordered, :type => :boolean, :default => true

end

class Manage::WebcamsController < Manage::ApplicationController

  actions :all

  has_scope :ordered, :default => 'title'

end

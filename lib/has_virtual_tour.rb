# encoding: utf-8

require 'active_support/concern'

module HasVirtualTour
  extend ActiveSupport::Concern

  included do
    has_one :virtual_tour, :as => :tourable
    attr_accessible :virtual_tour_attributes
    accepts_nested_attributes_for :virtual_tour, :allow_destroy => true, :reject_if => :all_blank
    delegate :link, :to => :virtual_tour, :prefix => true
  end

  def virtual_tour
    super || build_virtual_tour
  end
end

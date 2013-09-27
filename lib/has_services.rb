# encoding: utf-8

require 'active_support/concern'

module HasServices
  extend ActiveSupport::Concern

  included do
    attr_accessible :services_attributes

    has_many :services, as: :context, dependent: :destroy, order: 'id'

    accepts_nested_attributes_for :services, reject_if: :all_blank, allow_destroy: true
  end
end

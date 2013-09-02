module PaymentSystems
  extend ActiveSupport::Concern

  included do
    extend Enumerize

    attr_accessible :payment_system

    validates_presence_of :payment_system

    enumerize :payment_system, :in => [:robokassa, :rbkmoney]
  end
end

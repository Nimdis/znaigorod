module Copies
  extend ActiveSupport::Concern

  included do
    has_many :payments, dependent: :destroy
    has_many :copies, :as => :copyable, dependent: :destroy

    delegate :count, :for_sale, :reserved, :sold, to: :copies, prefix: true

    after_create :create_copies
  end

  private

  def create_copies
    number.times { copies.create! }
  end
end

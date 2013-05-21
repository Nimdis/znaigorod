module Copies
  extend ActiveSupport::Concern

  included do
    has_many :payments, :as => :paymentable, :class_name => 'CopyPayment'
    has_many :copies, :as => :copyable, dependent: :destroy

    delegate :count, :for_sale, :reserved, :sold, to: :copies, prefix: true

    after_create :create_copies

    scope :ordered,   -> { order('created_at DESC') }
    scope :actual,    -> { where('stale_at > ? OR stale_at IS NULL', Time.zone.now) }

    scope :available, -> { actual.ordered.joins(:copies).where('copies.state = ?', 'for_sale').uniq }
    scope :by_state,  ->(state) { ordered.joins(:copies).where('copies.state = ?', state).uniq }
  end

  private

  def create_copies
    number.times { copies.create! }
  end
end

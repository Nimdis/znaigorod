# encoding: utf-8

module Copies
  extend ActiveSupport::Concern

  included do
    has_many :copy_payments, :as => :paymentable
    has_many :copies, :as => :copyable, dependent: :destroy

    accepts_nested_attributes_for :copies
    attr_accessible :copies_attributes

    delegate :count, :for_sale, :reserved, :sold, to: :copies, prefix: true

    after_create :create_copies

    scope :ordered,   -> { order 'created_at DESC' }
    scope :actual,    -> { where 'stale_at > ?', Time.zone.now }
    scope :stale,     -> { where 'stale_at <= ?', Time.zone.now }
    scope :available, -> { actual.ordered.joins(:copies).where('copies.state = ?', 'for_sale').uniq }

    scope :by_state,  ->(state) { ordered.joins(:copies).where('copies.state = ?', state).uniq }
  end

  def copies_with_seats?
    copies.first.row?
  end

  private

  def create_copies
    number.times { copies.create! }
  end
end

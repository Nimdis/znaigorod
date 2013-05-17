class TicketInfo < ActiveRecord::Base
  attr_accessible :number, :original_price, :price, :description, :stale_at

  belongs_to :affiche

  has_many :payments, dependent: :destroy
  has_many :tickets, dependent: :destroy

  validates_presence_of :number, :original_price, :price, :description, :stale_at

  after_create :create_tickets

  delegate :count, :for_sale, :reserved, :sold, to: :tickets, prefix: true

  scope :ordered,   -> { order('created_at DESC') }
  scope :actual,    -> { where('stale_at > ? OR stale_at IS NULL', Time.zone.now) }
  scope :available, -> { actual.ordered.joins(:tickets).where('tickets.state = ?', 'for_sale').uniq }
  scope :by_state,  ->(state) { ordered.joins(:tickets).where('tickets.state = ?', state).uniq }

  def discount
    ((original_price - price) * 100 / original_price).round if tickets_for_sale.any?
  end

  def organization
    affiche(:include => { :showings => :organizatiob }).showings.first.organization
  end

  private

  def create_tickets
    number.times { tickets.create! }
  end
end

# == Schema Information
#
# Table name: ticket_infos
#
#  id             :integer          not null, primary key
#  affiche_id     :integer
#  number         :integer
#  original_price :float
#  price          :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#


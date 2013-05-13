class TicketInfo < ActiveRecord::Base
  attr_accessible :number, :original_price, :price, :description

  belongs_to :affiche

  has_many :payments, dependent: :destroy
  has_many :tickets, dependent: :destroy

  validates_presence_of :number, :original_price, :price, :description

  after_create :create_tickets

  delegate :for_sale, :reserved, :sold, to: :tickets, prefix: true

  def discount
    ((original_price - price) * 100 / original_price).round
  end

  private

  def create_tickets
    number.times do
      tickets.create!
    end
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


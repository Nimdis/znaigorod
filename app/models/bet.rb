class Bet < ActiveRecord::Base
  attr_accessible :amount, :number

  belongs_to :afisha
  belongs_to :user

  has_many :notification_messages, :as => :messageable, :dependent => :destroy

  has_one :account, :through => :user

  validates_presence_of :amount, :number

  after_create :send_notification_to_afisha_author

  default_value_for :number, 1

  state_machine :state, :initial => :fresh do
    event(:approve) { transition :fresh => :approved }
    event(:cancel) { transition :fresh => :canceled }

    after_transition :fresh => :canceled, :do => :handle_cancel
    after_transition :fresh => :approved, :do => :handle_approval
  end

  def price_min
    afisha_price_min = afisha.price_min

    (afisha_price_min - afisha_price_min * 0.3).round
  end

  private

  def send_notification_to_afisha_author
    notification_messages.create! :producer => account,
      :account => afisha.user.account, :kind => :auction_bet
  end

  def handle_cancel
    notification_messages.create! :producer => afisha.user.account,
      :account => account, :kind => :auction_bet_cancel
  end

  def handle_approval
    # отправлять пользователю уведомление со ссылкой на оплату
  end
end

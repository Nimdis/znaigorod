class Bet < ActiveRecord::Base
  attr_accessible :amount, :number

  belongs_to :afisha
  belongs_to :user

  validates_presence_of :amount, :number

  after_create :send_notification_to_afisha_author

  default_value_for :number, 1

  state_machine :state, :initial => :fresh do
    event(:approve) { transition :fresh => :approved }
    event(:cancel) { transition :fresh => :canceled }

    after_transition :fresh => :canceled, :do => :handle_cancel
    after_transition :fresh => :approved, :do => :handle_approval
  end

  scope :approved, -> { with_state :approved }
  scope :canceled, -> { with_state :canceled }

  def price_min
    afisha_price_min = afisha.price_min

    (afisha_price_min - afisha_price_min * 0.3).round
  end

  private

  def send_notification_to_afisha_author
    NotificationMessage.delay.create account: afisha.user.account, kind: :auction_bet, messageable: self
  end

  def handle_cancel
    # отправлять пользователю уведомление об отказе
  end

  def handle_approval
    # отправлять пользователю уведомление со ссылкой на оплату
  end
end

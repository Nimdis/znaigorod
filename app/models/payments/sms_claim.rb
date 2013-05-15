class SmsClaim < ActiveRecord::Base
  attr_accessible :details, :name, :phone

  belongs_to :claimed, :polymorphic => true

  validates_presence_of :details, :name

  validates :phone, presence: true, :format => { :with => /\+7-\(\d{3}\)-\d{3}-\d{4}/ }

  has_one :sms, :as => :smsable

  delegate :sms_claimable?, :to => :claimed

  before_validation :check_balance

  after_create :send_sms, :pay

  private

  def check_balance
    errors[:base] << I18n.t('activerecord.errors.messages.not_enough_money') unless claimed.enough_balance?
  end

  def send_sms
    create_sms! :phone => claimed.organization.phone_for_sms, :message => 'find me sms_claim.rb'
  end

  def pay
    organization = claimed.organization
    organization.balance_delta = -Settings['sms_claim.price']
    organization.save :validate => false
  end
end

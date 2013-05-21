# encoding: utf-8

class SmsClaim < ActiveRecord::Base
  attr_accessible :details, :name, :phone

  belongs_to :claimed, polymorphic: true

  validates_presence_of :name
  validates :phone, presence: true, format: { :with => /\+7-\(\d{3}\)-\d{3}-\d{4}/ }
  validates :details, presence: true, length: { maximum: 220 }

  has_many :smses, as: :smsable

  delegate :sms_claimable?, :to => :claimed

  before_validation :check_balance

  after_create :send_sms_to_organization, :send_sms_to_purchaser, :pay

  private

  def check_balance
    errors[:base] << I18n.t('activerecord.errors.messages.not_enough_money') unless claimed.enough_balance?
  end

  def send_sms_to_organization
    smses.create! :phone => claimed.organization.phone_for_sms, :message => message_for_organization
  end

  def send_sms_to_purchaser
    smses.create! :phone => phone, :message => 'Ваша заявка принята. Сотрудник заведения свяжется с вами.'
  end

  def pay
    organization = claimed.organization
    organization.balance_delta = -Settings['sms_claim.price']
    organization.save :validate => false
  end

  def normalized_phone
    phone.gsub(/[-()]/, '')
  end

  def message_for_organization
    "Поступила заявка. Имя: #{name}, тел: #{normalized_phone}. #{details}"
  end
end

# == Schema Information
#
# Table name: sms_claims
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  phone        :string(255)
#  details      :text
#  claimed_id   :integer
#  claimed_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#


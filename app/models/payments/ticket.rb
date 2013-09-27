# encoding: utf-8

class Ticket < ActiveRecord::Base
  include Copies
  extend Enumerize

  attr_accessible :number, :original_price, :price, :description,
    :stale_at, :organization_price, :email_addressess, :undertow, :state

  belongs_to :afisha

  validate :check_email_addressess, :if => :email_addressess?

  validates_presence_of :number, :original_price, :price, :description, :stale_at

  before_validation :normalize_email_addressess

  scope :for_stale, -> { where "stale_at <= ? AND (state = 'for_sale' OR state IS NULL)", Time.zone.now }
  scope :stale,    -> { by_state 'stale' }
  scope :without_report, -> { where :report_sended => false }
  scope :with_emails, -> { where 'email_addressess IS NOT NULL' }

  def organization
    afisha(:include => { :showings => :organizatiob }).showings.first.try(:organization)
  end

  delegate :title, :to => :afisha, :prefix => true
  delegate :title, :to => :organization, :prefix => true, :allow_nil => true

  enumerize :state,
    :in => [:for_sale, :stale],
    :default => :for_sale,
    :predicates => true

  searchable do
    text :afisha_title
    text :organization_title
  end

  def stale!
    update_attributes :state => 'stale'
    copies.map(&:stale!)
  end

  def discount
    ((original_price - (organization_price.to_f + price)) * 100 / original_price).round
  end

  def emails
    return [] unless email_addressess?

    email_addressess.split(', ').map(&:squish)
  end

  private

  def normalize_email_addressess
    self.email_addressess = email_addressess.split(',').map(&:squish).delete_if(&:blank?).join(', ') if email_addressess
  end

  def check_email_addressess
    invalid_emails = emails.select { |email| ValidatesEmailFormatOf::validate_email_format(email) }

    errors.add(:email_addressess, "неправильный формат: #{invalid_emails.join(', ')}") if invalid_emails.any?
  end
end

# == Schema Information
#
# Table name: tickets
#
#  id                 :integer          not null, primary key
#  afisha_id          :integer
#  number             :integer
#  original_price     :float
#  price              :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  description        :text
#  stale_at           :datetime
#  organization_price :float
#  email_addressess   :text
#  undertow           :integer
#  report_sended      :boolean          default(FALSE)
#  state              :string(255)
#


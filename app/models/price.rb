# encoding: utf-8

class Price < ActiveRecord::Base
  extend Enumerize

  attr_accessible :kind, :value, :count, :period, :description

  belongs_to :service

  enumerize :kind, in: [:single, :multiple, :certificate], predicates: true

  validates_presence_of :kind, :value
  validates_presence_of :count, :period, :if => :multiple?
  validates_presence_of :count, :if => :certificate?

  default_scope order('value ASC')

  def to_s
    if single?
      "#{I18n.t("price_kind.#{service.kind}", count: 1)} #{value} руб."
    else
      "#{kind_text} на #{I18n.t("price_kind.#{service.kind}", count: count)} #{period} #{value} руб."
    end
  end
end

# == Schema Information
#
# Table name: prices
#
#  id         :integer          not null, primary key
#  kind       :string(255)
#  value      :integer
#  count      :integer
#  period     :string(255)
#  service_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


class Sms < ActiveRecord::Base
  attr_accessible :phone, :message

  belongs_to :smsable, :polymorphic => true

  validates_presence_of :phone, :message, :smsable

  after_create :deliver

  private

  def sender
    'ZnaiGorod'
  end

  def sms
    @sms ||= MainsmsApi::Message.new(:sender => sender, :message => message, :recipients => [phone])
  end

  def deliver
    sms.deliver if Rails.env.production?
  end
end

class SmsClaim < ActiveRecord::Base
  attr_accessible :details, :name, :phone

  belongs_to :claimed, :polymorphic => true

  validates_presence_of :details, :name, :phone

  has_one :sms, :as => :smsable
  after_create :send_sms

  private

  def send_sms
    create_sms! :phone => claimed.organization.phone_for_sms
  end
end

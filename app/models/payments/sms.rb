class Sms < ActiveRecord::Base
  attr_accessible :phone

  belongs_to :smsable, :polymorphic => true

  validates_presence_of :phone, :smsable

  after_create :deliver

  private

  def deliver
    # TODO: implement delivery
  end
end

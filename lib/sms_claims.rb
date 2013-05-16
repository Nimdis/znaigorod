module SmsClaims
  extend ActiveSupport::Concern

  included do
    has_many :sms_claims, :as => :claimed, :dependent => :destroy

    delegate :enough_balance?, :sms_claimable?, :to => :organization
  end
end

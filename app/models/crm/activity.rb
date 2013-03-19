# == Schema Information
#
# Table name: activities
#
#  id              :integer          not null, primary key
#  title           :text
#  organization_id :integer
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  status          :string(255)
#  state           :string(255)
#  activity_at     :datetime
#  contact_id      :integer
#

class Activity < ActiveRecord::Base
  attr_accessible :title, :state, :activity_at, :user_id, :contact_id, :status

  belongs_to :organization
  belongs_to :manager, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :contact
  validates_presence_of :title, :state, :status, :activity_at, :manager
  after_save :set_organization_status, if: :state_completed?
  default_scope order('activity_at desc')

  searchable do
    string   :state
    string   :status
    integer  :user_id
    date     :activity_at
  end

  extend Enumerize
  enumerize :status, in: [:fresh, :talks, :waiting_for_payment, :client, :non_cooperation], default: :fresh
  enumerize :state, in: [:planned, :completed], default: :planned, predicates: { prefix: true }

  scope :with_state, ->(state) {where(state: state)}

  private
    def set_organization_status
      organization.status = status
      organization.save
    end
end

class Activity < ActiveRecord::Base
  attr_accessible :title, :state, :activity_at, :user_id, :contact_id, :status, :kind

  belongs_to :organization
  belongs_to :manager, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :contact
  validates_presence_of :title, :state, :status, :activity_at, :manager, :kind
  after_save :set_organization_status, if: :state_completed?
  default_scope order('activity_at desc')

  searchable do
    date(:activity_on) { activity_at.try :to_date }
    integer :user_id
    string  :kind
    string  :state
    string  :status
    time    :activity_at
  end

  extend Enumerize
  enumerize :status, in: [:fresh, :talks, :waiting_for_payment, :client, :non_cooperation], default: :fresh
  enumerize :state, in: [:planned, :completed], default: :planned, predicates: { prefix: true }
  enumerize :kind, in: [:phone, :email, :repeated_phone, :meeting, :meeting_contract, :meeting_payment]

  scope :with_state, ->(state) {where(state: state)}
  scope :with_meeting, -> {where(kind: [:meeting, :meeting_payment, :meeting_contract])}

  def activity_date
    activity_at.to_date
  end

  private

  def set_organization_status
    organization.status = status
    organization.save
  end
end

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
#  kind            :string(255)
#


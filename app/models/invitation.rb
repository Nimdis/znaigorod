class Invitation < ActiveRecord::Base
  extend Enumerize

  include PresentsAsCheckboxes

  attr_accessible :category, :category_list, :description, :kind, :gender, :invited_id

  belongs_to :account
  belongs_to :invited, :class_name => 'Account'
  belongs_to :inviteable, :polymorphic => true

  has_many :invite_messages, :as => :messageable, :dependent => :destroy

  validates_presence_of :kind

  after_create :create_invite_message, :if => :invited_id?
  after_create :create_visit, :if => :inviteable_type?

  delegate :index, :to => :account, :prefix => true
  after_save :account_index

  enumerize :gender, :in => [:all, :male, :female], :default => :all, :predicates => true
  enumerize :kind, :in => [:inviter, :invited], :scope => true

  presents_as_checkboxes :category,
    :validates_presence => true,
    :message => I18n.t('activerecord.errors.messages.at_least_one_value_should_be_checked')

  scope :inviter, -> { with_kind :inviter }
  scope :invited, -> { with_kind :invited }
  scope :without_invited, -> { where :invited_id => nil }
  scope :with_categories, -> { without_invited.where 'category IS NOT NULL' }

  def opposite_kind
    (self.class.kind.values - [kind]).join
  end

  def actual?
    return inviteable.actual? if inviteable.is_a?(Afisha)

    true
  end

  private

  def create_invite_message
    invite_messages.create!
  end

  def create_visit
    inviteable.visits.find_or_create_by_user_id account.users.first.id
  end
end

# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  inviteable_id   :integer
#  inviteable_type :string(255)
#  account_id      :integer
#  kind            :string(255)
#  category        :string(255)
#  description     :text
#  gender          :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  invited_id      :integer
#


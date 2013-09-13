class Invitation < ActiveRecord::Base
  extend Enumerize

  include PresentsAsCheckboxes

  attr_accessible :category, :category_list, :description, :kind, :gender

  belongs_to :account
  belongs_to :inviteable, :polymorphic => true

  validates_presence_of :kind

  enumerize :gender, :in => [:all, :male, :female], :default => :all, :predicates => true
  enumerize :kind, :in => [:inviter, :invited], :scope => true

  presents_as_checkboxes :category,
    :validates_presence => true,
    :message => I18n.t('activerecord.errors.messages.at_least_one_value_should_be_checked')

  scope :inviter, -> { with_kind :inviter }
  scope :invited, -> { with_kind :invited }
end

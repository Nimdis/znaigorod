# encoding: utf-8

class Friend < ActiveRecord::Base
  attr_accessible :friendly, :friendable, :account_id

  belongs_to :account
  belongs_to :friendable, :polymorphic => true

  has_many :messages, :as => :messageable, :dependent => :destroy

  scope :approved, -> { where(friendly: true) }

  delegate :first_name, :last_name, :patronymic, :nickname, :to => :friendable
  searchable do
    integer :account_id

    text :first_name
    text :last_name
    text :patronymic
    text :nickname
  end

  def change_friendship
    self.friendly = !friendly?
    self.save
  end
end

# == Schema Information
#
# Table name: friends
#
#  id              :integer          not null, primary key
#  account_id      :integer
#  friendable_id   :integer
#  friendable_type :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  friendly        :boolean          default(FALSE)
#


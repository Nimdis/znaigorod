# encoding: utf-8

class Comment < ActiveRecord::Base
  belongs_to :user
  has_one :account, through: :user
  belongs_to :commentable, :polymorphic => true
  attr_accessible :ancestry, :body, :parent_id

  has_ancestry
  has_many :votes, :as => :voteable, :dependent => :destroy
  has_many :messages, :as => :messageable, :dependent => :destroy

  scope :rendereable,      -> { where(:commentable_type => ['Afisha', 'Organization']) }

  normalize_attribute :body, :ancestry
  validates_presence_of :body
  validate :authenticated_user

  def name
    user ? account.title : 'неизвестный автор'
  end

  def avatar
    user ?  account.avatar : Account.new.avatar
  end

  private
    def authenticated_user
      errors.add :body, 'Комментарии могут оставлять только зарегистрированные пользователи' if user.nil?
    end
end

# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  commentable_id   :integer
#  commentable_type :string(255)
#  body             :text
#  ancestry         :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#


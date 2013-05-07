# encoding: utf-8

class Visit < ActiveRecord::Base
  attr_accessible :voted, :user_id

  belongs_to :visitable, :polymorphic => true
  belongs_to :user

  validate :authenticated_user

  scope :voted, where(:voted => true)

  private

    def authenticated_user
      errors.add :voted, 'Вы не зарегистрированы' if user.nil?
    end
end

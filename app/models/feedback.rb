# encoding: utf-8

class Feedback < ActiveRecord::Base
  attr_accessible :email, :fullname, :message

  validates_presence_of :fullname, :email, :message
  validates_format_of :fullname, :with => /\A([ёЁа-яА-Я]+\s*)+\z/
  validates :email, :email_format => { :message => I18n.t('activerecord.errors.messages.invalid') }

end

# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  message    :text
#  fullname   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


# encoding: utf-8

class Schedule < ActiveRecord::Base
  belongs_to :organization

  attr_accessible :day, :from, :to

  validates_presence_of :day, :from, :to

  default_scope order(:day)

  def self.days_for_select
    array = I18n.t('date.standalone_day_names').dup
    sunday = array.shift
    array << sunday
    array.each_with_index.map { |e, i| [e, i + 1] }
  end

  def human_day
    self.class.days_for_select[day-1].first
  end

  def to_s
    "#{human_day} c #{I18n.l(from, :format => "%H:%M")} до #{I18n.l(to, :format => "%H:%M")}"
  end
end

# == Schema Information
#
# Table name: schedules
#
#  id              :integer         not null, primary key
#  day             :integer
#  from            :time
#  to              :time
#  organization_id :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#


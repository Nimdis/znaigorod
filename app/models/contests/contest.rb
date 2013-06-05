# encoding: utf-8

class Contest < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :title, :description, :ends_on, :starts_on, :vfs_path

  has_many :works, :dependent => :destroy

  validates_presence_of :title

  scope :ordered_by_starts_on, order('starts_on desc')

  friendly_id :title, use: :slugged

  def self.generate_vfs_path
    "/znaigorod/contests/#{Time.now.strftime('%Y/%m/%d/%H-%M')}-#{SecureRandom.hex(4)}"
  end
end

# == Schema Information
#
# Table name: contests
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  starts_on   :date
#  ends_on     :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  vfs_path    :string(255)
#  slug        :string(255)
#


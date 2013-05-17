class Work < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :author_info, :image_url, :title, :description

  belongs_to :contest

  has_many :votes, :as => :voteable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy

  validates_presence_of :image_url

  friendly_id :title, use: :slugged

  scope :ordered, order('created_at desc')
  scope :ordered_by_likes, order('vk_likes desc')

  def vfs_path
    "/znaigorod/contests/#{contest.id}"
  end
end

# == Schema Information
#
# Table name: works
#
#  id          :integer          not null, primary key
#  image_url   :text
#  author_info :string(255)
#  contest_id  :integer
#  title       :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string(255)
#  vk_likes    :integer
#


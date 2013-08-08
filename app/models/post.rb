# encoding: utf-8

class Post < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :annotation, :content, :poster_url, :status, :title, :vfs_path

  has_many :post_images, :order => 'post_images.created_at'
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :votes, :as => :voteable, :dependent => :destroy

  validates_presence_of :annotation, :content, :title

  alias_attribute :description, :annotation

  friendly_id :title, use: :slugged

  default_scope order('id DESC')

  scope :published, -> { where(:status => true) }
  scope :draft,     -> { where(:status => false) }

  def self.generate_vfs_path
    "/znaigorod/posts/#{Time.now.strftime('%Y/%m/%d/%H-%M')}-#{SecureRandom.hex(4)}"
  end

  searchable do
    text :title,                :more_like_this => true
    text :annotation,           :more_like_this => true
    text :content,              :more_like_this => true
    string :search_kind
  end

  def search_kind
    self.class.name.underscore
  end

  def similar_posts
    HasSearcher.searcher(:similar_posts).more_like_this(self).limit(3).results
  end

  def poster_url
    post_images.any? ? post_images.first.attachment_url : 'public/stub_poster.png'
  end
end

# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :text
#  annotation :text
#  content    :text
#  poster_url :text
#  vfs_path   :string(255)
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :boolean          default(FALSE)
#


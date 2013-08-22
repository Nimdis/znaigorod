# encoding: utf-8

class Post < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :annotation, :content, :poster_url, :status, :title, :vfs_path, :rating, :tag

  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :gallery_images, :as => :attachable, :dependent => :destroy
  has_many :votes, :as => :voteable, :dependent => :destroy

  validates_presence_of :annotation, :content, :title

  alias_attribute :description, :annotation

  friendly_id :title, use: :slugged

  extend Enumerize
  serialize :kind, Array
  enumerize :kind, in: [:review, :photoreport], multiple: true, predicates: true

  normalize_attribute :kind, with: :blank_array

  default_scope order('id DESC')

  scope :published, -> { where(:status => true) }
  scope :draft,     -> { where(:status => false) }

  def self.generate_vfs_path
    "/znaigorod/posts/#{Time.now.strftime('%Y/%m/%d/%H-%M')}-#{SecureRandom.hex(4)}"
  end

  searchable do
    text :annotation,           :more_like_this => true
    text :content,              :more_like_this => true
    text :title,                :more_like_this => true, :stored => true
    date :created_at
    float :rating,              :trie => true
    string :search_kind
    string(:kind, :multiple => true) { kind.map(&:value) }
  end

  def search_kind
    self.class.name.underscore
  end

  def similar_post
    HasSearcher.searcher(:similar_posts).more_like_this(self).limit(6).results
  end

  def poster_url
    gallery_images.any? ? gallery_images.first.file_url : 'public/stub_poster.png'
  end

  def tags
    tag.to_s.split(/,\s+/).map(&:mb_chars).map(&:downcase).map(&:squish)
  end

  def images
    gallery_images
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


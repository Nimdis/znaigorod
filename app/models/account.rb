class Account < ActiveRecord::Base
  attr_accessible :avatar, :email, :first_name, :gender, :last_name, :patronymic, :rating, :nickname, :location, :created_at

  has_many :users,           order: 'id ASC'
  has_many :afisha,          through: :users
  has_many :showings,        through: :users
  has_many :comments,        through: :users, order: 'comments.created_at DESC'
  has_many :roles,           through: :users
  has_many :votes,           through: :users, order: 'votes.created_at DESC'
  has_many :visits,          through: :users, order: 'visits.created_at DESC'
  has_many :page_visits,     through: :users
  has_many :payments,        through: :users
  has_many :events,          through: :users, order: 'afisha.created_at DESC'

  has_many :friends
  has_many :messages,        order: 'messages.created_at DESC'

  has_many :roles,           through: :users

  after_create :get_social_avatar

  alias_attribute :to_s, :title

  scope :ordered, -> { order('ID ASC') }

  has_attached_file :avatar, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  extend Enumerize
  enumerize :gender, in: [:male, :female], predicates: true

  searchable do
    text :first_name
    text :last_name
    text :patronymic
    text :nickname
    text :location
    text :title,     :stored => true

    string :gender
    float :rating,   :trie => true
    string :search_kind
    string(:kind, :multiple => true) { roles.map(&:role) }
  end

  def search_kind
    self.class.name.underscore
  end

  def title
    "#{first_name} #{last_name}"
  end

  def get_vkontakte_friends(user)
    vk_client = VkontakteApi::Client.new
    uids = vk_client.friends.get(user_id: user.uid)

    uids.each do |uid|
      if User.vkontakte.where(uid: uid.to_s).any?
        self.friends.create(friendable: get_account(uid.to_s), friendly: true) unless self.friends_with?(get_account(uid.to_s))
      end
    end
  end

  def get_facebook_friends(user)
    fb_client = Koala::Facebook::API.new(user.token)
    friends = fb_client.get_connections(user.uid, "friends")
    friends.each do |friend|
      if User.facebook.where(uid: friend['id']).any?
        self.friends.create(friendable: get_account(friend['id']), friendly: true) unless self.friends_with?(get_account(friend['id']))
      end
    end
  end

  def get_social_avatar
    user = users.first
    vk_client = VkontakteApi::Client.new
    fb_client = Koala::Facebook::API.new
    image_url = case user.provider
                when 'vkontakte'
                  vk_client.users.get(uid: user.uid,
                                      fields: :photo_200_orig).first.photo_200_orig
                when 'facebook'
                  fb_client.get_picture(user.uid, type: 'large')
                when 'google_oauth2', 'twitter'
                  user.avatar
                end
    set_avatar_from_url(image_url) if image_url
  end

  def set_avatar_from_url(url)
    self.avatar = URI.parse(url)
    save!
  end

  def get_account(uid)
    User.find_by_uid(uid).account
  end

  def update_rating
    rating = (self.afisha.count * 0.5 + self.comments.count * 0.25 + self.votes.count * 0.125 + self.visits.count * 0.125 + self.page_visits.count * 0.01) / 5
    rating *= 10 if self.avatar_url?
    update_attribute(:rating, rating)
  end

  def friendly_for(account)
    self.friends.where(friendable_id: account.id)
  end

  def friends_with?(account)
    self.friends.where(friendable_id: account.id, friendly: true).any?
  end

end

# == Schema Information
#
# Table name: accounts
#
#  id                  :integer          not null, primary key
#  first_name          :string(255)
#  last_name           :string(255)
#  patronymic          :string(255)
#  email               :string(255)
#  rating              :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  nickname            :string(255)
#  location            :string(255)
#  gender              :string(255)
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  avatar_url          :text
#


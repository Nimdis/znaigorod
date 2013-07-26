class Account < ActiveRecord::Base
  acts_as_follower
  acts_as_followable

  attr_accessible :email, :first_name, :last_name, :patronymic, :rating, :nickname, :location

  has_many :users,           order: 'id ASC'
  has_many :afisha,          :through => :users
  has_many :showings,        :through => :users
  has_many :activities,      :through => :users
  has_many :comments,        :through => :users
  has_many :organizations,   :through => :users
  has_many :roles,           :through => :users
  has_many :votes,           :through => :users
  has_many :visits,          :through => :users
  has_many :payments,        :through => :users
  has_many :events,          :through => :users

  scope :ordered, -> { order('ID ASC') }

  searchable do
    text :first_name
    text :last_name
    text :patronymic
    text :nickname
    text :location

    string :rating
  end

  def get_vkontakte_friends(user)
    vk_client = VkontakteApi::Client.new
    uids = vk_client.friends.get(user_id: user.uid)

    uids.each do |uid|
      self.follow!(User.find_by_uid(uid.to_s).account) if User.vkontakte.where(uid: uid.to_s).any?
    end
  end

  def get_facebook_friends(user)
    fb_client = Koala::Facebook::API.new(user.token)
    friends = fb_client.get_connections(user.uid, "friends")
    friends.each do |friend|
      self.follow!(User.find_by_uid(friend['id']).account) if User.facebook.where(uid: friend['id']).any?
    end
  end

  def update_rating
    rating = self.comments.count * 0.5 + self.votes.count * 0.25 + self.visits.count * 0.25
    update_column(:rating, rating)
  end
end

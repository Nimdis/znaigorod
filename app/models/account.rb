class Account < ActiveRecord::Base
  acts_as_follower
  acts_as_followable

  attr_accessible :email, :first_name, :last_name, :patronymic, :rating, :nickname, :location
  has_many :users

  scope :ordered, -> { order('ID ASC') }

  def get_vkontakte_friends(user)
    vk_client = VkontakteApi::Client.new
    uids = vk_client.friends.get(user_id: user.uid)

    uids.each do |uid|
      self.follow!(User.find_by_uid(uid.to_s).account) if User.vkontakte.where(uid: uid.to_s).any?
    end
  end
end

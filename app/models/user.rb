# encoding: utf-8

class User < ActiveRecord::Base
  attr_accessible :uid, :provider, :auth_raw_info, :roles_attributes, :account_id

  devise :trackable, :omniauthable, :rememberable,
    omniauth_providers: [:vkontakte, :google_oauth2, :yandex, :facebook, :twitter, :odnoklassniki, :mailru]

  has_many :afisha,         uniq: true
  has_many :showings,       through: :afisha
  has_many :activities,     dependent: :destroy
  has_many :comments,       order: 'comments.created_at DESC'
  has_many :organizations
  has_many :roles,          dependent: :destroy
  has_many :votes
  has_many :visits
  has_many :payments
  has_many :events, :class_name => 'Afisha'

  belongs_to :account

  serialize :auth_raw_info

  validates_presence_of :provider, :uid

  accepts_nested_attributes_for :roles, allow_destroy: true, reject_if: :all_blank

  scope :with_role,      ->(role) { joins(:roles).where('roles.role = ?', role) }
  scope :sales_managers, -> { with_role(:sales_manager) }
  scope :vkontakte,      -> { where(provider: 'vkontakte') }
  scope :facebook,       -> { where(provider: 'facebook') }
  scope :ordered,        -> { order('ID ASC') }

  after_create :create_account

  def self.find_or_create_by_oauth(auth_raw_info)
    provider, uid = auth_raw_info.provider, auth_raw_info.uid.to_s

    find_or_initialize_by_provider_and_uid(provider: provider, uid: uid).tap { |user|
      user.update_attributes provider: provider, uid: uid, auth_raw_info: auth_raw_info
    }
  end

  def token
    auth_raw_info.try(:credentials).try(:token)
  end

  def name
    auth_raw_info.try(:info).try(:name) || 'Mister X'
  end

  def nickname
    auth_raw_info.try(:info).try(:nickname)
  end

  def gender
    auth_raw_info.try(:extra).try(:raw_info).try(:gender) || auth_raw_info.try(:extra).try(:raw_info).try(:sex)
  end

  def email
    auth_raw_info.try(:extra).try(:raw_info).try(:email)
  end

  def location
    auth_raw_info.try(:info).try(:location)
  end

  alias_attribute :to_s, :name

  def remember_me
    true
  end

  def vote_for(voteable)
    voteable.votes.where(:user_id => self.id)
  end

  def voted?(voteable)
    vote_for(voteable).one?
  end

  def liked?(voteable)
    voted?(voteable) && vote_for(voteable).first.like?
  end

  def visit_for(visitable)
    visitable.visits.where(:user_id => self.id)
  end

  def visitd?(visitable)
    visit_for(visitable).one?
  end

  def visited?(visitable)
    visitd?(visitable) && visit_for(visitable).first.visited?
  end

  def avatar
    case provider
    when 'google_oauth2'
      auth_raw_info.try(:[], :info).try(:[], :image)
    when 'facebook'
      auth_raw_info.try(:[], :info).try(:[], :image)
    when 'vkontakte'
      auth_raw_info.try(:[], :extra).try(:[], :raw_info).try(:[], :photo_big)
    when 'mailru'
      auth_raw_info.try(:[], :extra).try(:[], :raw_info).try(:[], :pic)
    when 'odnoklassniki'
      Settings['app.odnoklassniki_avatar_url']
    when 'twitter'
      link = auth_raw_info.try(:[], :info).try(:[], :image)
      if link
        link = link.gsub(/_\w+\.jpeg\z/,'')+'.jpeg'
      end
    else
      Settings['app.default_avatar_url']
    end
  end

  def profile
    case provider
    when 'vkontakte', 'facebook', 'twitter', 'odnoklassniki', 'mailru'
      auth_raw_info[:info][:urls][provider.capitalize.to_sym]
    when 'google_oauth2'
      auth_raw_info[:extra][:raw_info][:link]
    else
      nil
    end
  end

  Role.role.values.each do |value|
    define_method "is_#{value}?" do
      roles.pluck(:role).include?(value)
    end
  end

  def manager_of?(organization)
    is_sales_manager? && organization.manager == self
  end

  private

  def create_account
    name = self.name.split(' ')
    account = Account.create(first_name: name.first, last_name: name.last,
                             nickname: self.nickname, location: self.location,
                             email: self.email, gender: self.gender)

    update_attributes(account_id: account.id)
  end
end

# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  roles_mask          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  uid                 :string(255)
#  sign_in_count       :integer          default(0)
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  provider            :string(255)
#  auth_raw_info       :text
#  remember_created_at :datetime
#  remember_token      :string(255)
#  rating              :string(255)
#  account_id          :integer
#


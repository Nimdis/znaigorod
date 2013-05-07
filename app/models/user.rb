class User < ActiveRecord::Base
  attr_accessible :uid, :provider, :auth_raw_info, :roles_attributes

  devise :trackable, :omniauthable, :rememberable,
    omniauth_providers: [:vkontakte, :google_oauth2, :yandex, :facebook, :twitter, :odnoklassniki, :mailru]

  has_many :activities,     dependent:  :destroy
  has_many :comments
  has_many :organizations
  has_many :roles,          dependent: :destroy
  has_many :votes
  has_many :visits

  serialize :auth_raw_info

  validates_presence_of :provider, :uid

  accepts_nested_attributes_for :roles, allow_destroy: true, reject_if: :all_blank

  scope :with_role,      ->(role) { joins(:roles).where('roles.role = ?', role) }
  scope :sales_managers, -> { with_role(:sales_manager) }

  def self.find_or_create_by_oauth(auth_raw_info)
    provider, uid = auth_raw_info.provider, auth_raw_info.uid.to_s

    find_or_initialize_by_provider_and_uid(provider: provider, uid: uid).tap { |user|
      user.update_attributes provider: provider, uid: uid, auth_raw_info: auth_raw_info
    }
  end

  def name
    auth_raw_info.try(:info).try(:name) || 'Mister X'
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
    when 'vkontakte', 'google_oauth2', 'facebook', 'twitter'
      auth_raw_info.try(:[], :info).try(:[], :image)
    when 'mailru'
      auth_raw_info.try(:[], :extra).try(:[], :raw_info).try(:[], :pic)
    when 'odnoklassniki'
      Settings['app.odnoklassniki_avatar_url']
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

  # TODO: depricated
  def roles_from_mask
    roles = %w[admin affiches_editor organizations_editor posts_editor sales_manager]

    roles.reject do |r|
      ((roles_mask || 0) & 2**roles.index(r)).zero?
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  oauth_key  :string(255)
#  roles_mask :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  uid        :integer
#


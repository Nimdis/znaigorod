class User < ActiveRecord::Base
  attr_accessible :uid, :roles_mask, :roles, :provider, :auth_raw_info

  devise :trackable, :omniauthable, omniauth_providers: [:vkontakte, :google_oauth2, :yandex]

  has_many :activities,     dependent:  :destroy
  has_many :comments
  has_many :organizations
  has_many :roles,          dependent: :destroy

  serialize :auth_raw_info

  validates_presence_of :provider, :uid

  def self.find_or_create_by_oauth(auth_raw_info)
    provider, uid = auth_raw_info.provider, auth_raw_info.uid.to_s

    find_or_initialize_by_provider_and_uid(provider: provider, uid: uid).tap { |user|
      user.update_attributes provider: provider, uid: uid, auth_raw_info: auth_raw_info
    }
  end

  def name
    auth_raw_info.info.name
  end

  # If production, do not change existing roles. You can only add new one to the end
  ROLES = %w[admin affiches_editor organizations_editor posts_editor sales_manager]

  #FILTER = {
              #I18n.t('manage.admin.without_role') => "nil",
              #I18n.t('manage.admin.all_users') => "all_users",
              #I18n.t('manage.admin.editor.affiche') => "affiches_editor",
              #I18n.t('manage.admin.editor.organization') => "organizations_editor",
              #I18n.t('manage.admin.editor.post') => "posts_editor",
              #I18n.t('manage.admin.sales_manager') => "sales_manager",
              #I18n.t('manage.admin.admin') => "admin"
           #}

  #FIELDS = Hash[FILTER.to_a[2..-1]]



  #scope :with_role, ->(role) do
    #if role.nil? || role == "nil"
      #where(:roles_mask => nil)
    #elsif ROLES.exclude?(role)
      #all
    #else
      #{:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"}
    #end
  #end

  #scope :sales_managers,  with_role("sales_manager")

  #def roles=(roles)
    #self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  #end

  def roles_from_mask
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

  #def is?(role)
    #roles.include?(role.to_s)
  #end

  #def manager_of?(organization)
    #is?(:sales_manager) && organization.manager == self
  #end

  alias_attribute :to_s, :name

  def avatar
    case provider
    when 'vkontakte'
      return auth_raw_info[:info][:image]
    else
      return 'http://placekitten.com/g/50/50'
    end
  end

  def profile
    case provider
    when 'vkontakte'
      return auth_raw_info[:info][:urls][:Vkontakte]
    else
      return 'http://google.ru'
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


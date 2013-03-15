class User < ActiveRecord::Base
  attr_accessible :uid, :name, :oauth_key, :roles_mask, :roles

  # If production, do not change existing roles. You can only add new one to the end
  ROLES = %w[admin affiches_editor organizations_editor posts_editor sales_manager]

  FILTER = {
              I18n.t('manage.admin.without_role') => "nil",
              I18n.t('manage.admin.all_users') => "all_users",
              I18n.t('manage.admin.editor.affiche') => "affiches_editor",
              I18n.t('manage.admin.editor.organization') => "organizations_editor",
              I18n.t('manage.admin.editor.post') => "posts_editor",
              I18n.t('manage.admin.sales_manager') => "sales_manager",
              I18n.t('manage.admin.admin') => "admin"
           }

  FIELDS = Hash[FILTER.to_a[2..-1]]

  has_many :organizations

  validates_presence_of :uid, :oauth_key

  scope :with_role, ->(role) do
    if role.nil? || role == "nil"
      where(:roles_mask => nil)
    elsif ROLES.exclude?(role)
      all
    else
      {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"}
    end
  end

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def is?(role)
    roles.include?(role.to_s)
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
#


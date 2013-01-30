class User < ActiveRecord::Base
  attr_accessible :email, :name, :oauth_key, :roles_mask

  # If production, do not change existing roles. You can only add new one to the end
  ROLES = %w[admin affiche_editor organization_editor post_editor sales_manager]

  validates :oauth_key, :presence => true

  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }


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
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  oauth_key       :string(255)      unique
#  roles_mask      :integer
#

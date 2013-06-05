# encoding: utf-8

class Ability
  include CanCan::Ability

  def initialize(user, namespace=nil)
    user ||= User.new

    can :manage, :all     if user.is_admin?
    can :manage, :crm     if user.is_admin? || user.is_sales_manager?

    case namespace
    when 'manage'
      can :manage, Affiche if user.is_affiches_editor?
      can :manage, Post    if user.is_posts_editor?

      if user.is_organizations_editor?
        can :manage, [Organization] + Organization.available_suborganization_classes
      end
    when 'crm'
      return false if user.new_record?

      can :manage, Organization do |organization|
        organization.manager.nil? || user.manager_of?(organization)
      end

      can :manage, Activity do |activity|
        user.manager_of?(activity.organization)
      end

      can :manage, Contact do |contact|
        user.manager_of?(contact.organization)
      end
    end
  end
end

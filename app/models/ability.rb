class Ability
  include CanCan::Ability

  def initialize(user, namespace=nil)
    user ||= User.new
    can :manage, :all         if user.is? :admin
    can :manage, :crm         if user.is?(:admin) || user.is?(:sales_manager)
    can :create, Comment      if user.persisted?

    case namespace
    when 'manage'
      can :manage, Affiche      if user.is? :affiches_editor
      can :manage, Post         if user.is? :posts_editor
      if user.is? :organizations_editor
        can :manage, [Organization] + Organization.available_suborganization_classes
      end
    when 'crm'
      can :manage, Organization do |organization|
        organization.manager.nil? ||  user.manager_of?(organization)
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

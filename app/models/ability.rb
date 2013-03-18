class Ability
  include CanCan::Ability

  def initialize(user, namespace)
    user ||= User.new
    can :manage, :all         if user.is? :admin
    can :manage, :crm         if user.is?(:admin) || user.is?(:sales_manager)

    case namespace
    when 'manage'
      can :manage, Affiche      if user.is? :affiches_editor
      can :manage, Post         if user.is? :posts_editor
      if user.is? :organizations_editor
        can :manage, [Organization, Sauna, Meal, Entertainment,
                      Culture, Sport, Billiard, Creation]
      end
    when 'crm'
      can :manage, :crm
    end

  end
end

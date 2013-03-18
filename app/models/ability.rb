class Ability
  include CanCan::Ability

  def initialize(user, namespace)
    can :manage, :all         if user.is? :admin
    case namespace
    when 'manage'
      can :manage, Affiche      if user.is? :affiches_editor
      can :manage, Post         if user.is? :posts_editor
      if user.is? :organizations_editor
        can :manage, [Organization, Sauna, Meal, Entertainment,
                      Culture, Sport, Billiard, Creation]
      end
    when 'crm'
      can :manage, :all if user.is? :sales_manager
    end

  end
end

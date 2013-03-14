class Ability
  include CanCan::Ability

  def initialize(user)

    can :manage, :all         if user.is? :admin
    can :manage, Affiche      if user.is? :affiches_editor
    can :manage, Post         if user.is? :posts_editor

    if user.is? :organizations_editor
      can :manage, [Organization, Sauna, Meal, Entertainment,
                    Culture, Sport, Billiard, Creation]
    end

  end
end

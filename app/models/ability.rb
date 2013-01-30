class Ability
  include CanCan::Ability

  def initialize(user)

    can :manage, :all         if user.is? :admin
    can :manage, Affiche      if user.is? :affiche_editor
    can :manage, Post         if user.is? :post_editor

    if user.is? :organization_editor
      can :manage, [Organization, Sauna, Meal, Entertainment,
                    Culture, Sport, Billiard, Creation]
    end

  end
end

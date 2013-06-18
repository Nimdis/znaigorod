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
    when 'my'
      can [:index, :show, :archive, :new, :create, :available_tags, :preview_video], Affiche if user.persisted?
      can [:edit, :update, :destroy_image], Affiche do |affiche|
        affiche.state != 'pending' && affiche.user == user
      end

      can [:destroy, :send_to_moderation], Affiche do |affiche|
        affiche.draft? && affiche.user == user
      end

      can :send_to_published, Affiche if user.is_affiches_trusted_editor?

      can :manage, GalleryFile do |gallery_file|
        gallery_file.attachable.state != 'pending' && gallery_file.attachable.user == user
      end

      can :manage, GalleryImage do |gallery_image|
        gallery_image.attachable.state != 'pending' && gallery_image.attachable.user == user
      end

      can :manage, Showing do |showing|
        showing.affiche.state != 'pending' && showing.affiche.user == user
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

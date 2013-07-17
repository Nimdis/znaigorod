# encoding: utf-8

class Ability
  include CanCan::Ability

  def initialize(user, namespace=nil)
    user ||= User.new

    can :manage, :all     if user.is_admin?
    can :manage, :crm     if user.is_admin? || user.is_sales_manager?

    case namespace
    when 'manage'
      can :manage, Afisha if user.is_afisha_editor?
      can :manage, Post    if user.is_posts_editor?

      if user.is_organizations_editor?
        can :manage, [Organization] + Organization.available_suborganization_classes
      end
    when 'my'
      can [:index, :archive, :new, :create, :available_tags, :preview_video], Afisha if user.persisted?

      can [:edit, :update, :destroy_image], Afisha do |afisha|
        afisha.state != 'pending' && afisha.user == user
      end

      can [:destroy, :send_to_moderation], Afisha do |afisha|
        afisha.draft? && afisha.user == user
      end

      can :show, Afisha do |afisha|
        afisha.user == user
      end

      can :send_to_published, Afisha if user.is_afisha_trusted_editor?

      can :manage, GalleryFile do |gallery_file|
        gallery_file.attachable.state != 'pending' && gallery_file.attachable.user == user
      end

      can :social_gallery, Afisha do |afisha|
        afisha.state != 'pending' && afisha.user == user
      end

      can :manage, GalleryImage do |gallery_image|
        gallery_image.attachable.state != 'pending' && gallery_image.attachable.user == user
      end

      can [:destroy, :destroy_all], GallerySocialImage do |gallery_social_image|
        gallery_social_image.attachable.state != 'pending' && gallery_social_image.attachable.user == user
      end

      can :manage, Showing do |showing|
        showing.afisha.state != 'pending' && showing.afisha.user == user
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

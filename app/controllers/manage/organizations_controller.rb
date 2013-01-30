class Manage::OrganizationsController < Manage::ApplicationController
  skip_load_and_authorize_resource
  has_scope :ordered_by_updated_at, :default => true, :type => :boolean
  has_scope :page, :default => 1
  has_scope :parental, :default => true, :type => :boolean, :only => :index

  belongs_to :organization, :optional => true

  before_filter :check_role
  before_filter :build_resource, :only => :new
  before_filter :build_nested_objects, :only => [:new, :edit]

  respond_to :html, :json

  private

  def build_nested_objects
    resource.organization_stand || resource.build_organization_stand
    resource.address || resource.build_address

    (1..7).each do |day|
      resource.schedules.build(:day => day)
    end unless resource.schedules.any?
  end

  alias_method :old_collection, :collection
  def collection
    if params[:utf8]
      HasSearcher.searcher(:manage_organization, params).paginate(:page => params[:page], :per_page => per_page).results
    else
      old_collection
    end
  end

  def check_role
    roles = current_user.roles
    unless roles.include? "organization_editor"
      redirect_to manage_affiches_path if roles.include? "affiche_editor"
      redirect_to manage_posts_path if roles.include? "post_editor"
    end
  end
end

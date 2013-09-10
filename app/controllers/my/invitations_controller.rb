class My::InvitationsController < My::ApplicationController
  actions :all, :except => [:index, :show]

  skip_authorization_check

  layout false

  protected

  def begin_of_association_chain
    current_user.account
  end
end

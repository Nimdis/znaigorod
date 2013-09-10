class My::InvitationsController < My::ApplicationController
  actions :all

  skip_authorization_check

  layout false

  protected

  def begin_of_association_chain
    current_user.account
  end
end

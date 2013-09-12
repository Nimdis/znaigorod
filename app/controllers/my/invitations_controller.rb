class My::InvitationsController < My::ApplicationController
  actions :all, :except => [:index, :edit, :update]

  skip_authorization_check

  layout false

  #def create
    #create! { render @invitation and return }
  #end

  def destroy
    destroy! { render :nothing => true and return }
  end

  protected

  def begin_of_association_chain
    current_user.account
  end
end

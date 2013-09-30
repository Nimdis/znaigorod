class My::InviteMessagesController < My::ApplicationController
  load_and_authorize_resource

  actions :update, :show, :index

  layout false

  def update
    update! do
      render @invite_message and return
    end
  end

  protected

  def resource
    @invite_message = begin_of_association_chain.received_invite_messages.find(params[:id])
  end

  def collection
    @invite_messages = Kaminari.paginate_array([super, begin_of_association_chain.received_invite_messages].flatten.sort_by(&:created_at).reverse!).page(params[:page]).per(5)
  end

  def begin_of_association_chain
    #authorize! current_user, InviteMessage.new(producer: current_user.try(:account))
    current_user.account
  end
end

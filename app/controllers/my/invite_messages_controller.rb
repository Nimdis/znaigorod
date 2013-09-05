class My::InviteMessagesController < My::ApplicationController
  load_and_authorize_resource

  actions :create, :update, :show, :index
  custom_actions resource: :change_message_status

  layout false

  def create
    create! do
      render @invite_message and return
    end
  end

  def update
    update! do
      render @invite_message and return
    end
  end

  def change_message_status
    change_message_status! {
      @invite_message.change_message_status

      render @invite_message and return
    }
  end

  protected

  def collection
    @invite_messages = Kaminari.paginate_array([super, begin_of_association_chain.produced_invite_messages].flatten.sort_by(&:created_at).reverse!).page(params[:page]).per(5)
  end

  def begin_of_association_chain
    authorize! current_user, InviteMessage.new(producer: current_user.try(:account))
    current_user.account
  end

  def build_resource
    @invite_message = begin_of_association_chain.produced_invite_messages.build(params[:invite_message])
  end
end

class My::PrivateMessagesController < My::ApplicationController
  load_and_authorize_resource

  actions :create, :new, :show
  custom_actions resource: :change_message_status

  layout false

  def new
    new! {
      @private_message.account_id = params[:account_id]
      @dialog_with = Account.find(@private_message.account_id)
      render partial: 'my/private_messages/form' and return
    }
  end

  def create
    create! do |success, failure|
      success.html { render @private_message }
      failure.html { render partial: 'my/private_messages/form' }
    end
  end

  def change_message_status
    change_message_status! {
      @private_message.change_message_status

      render partial: 'my/private_messages/private_message', locals: { message: @private_message } and return
    }
  end

  protected

  def begin_of_association_chain
    authorize! current_user, PrivateMessage.new(producer: current_user.try(:account))
    current_user.account
  end

  def build_resource
    @private_message = begin_of_association_chain.produced_messages.build(params[:private_message])
  end
end

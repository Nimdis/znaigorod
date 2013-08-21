class My::PrivateMessagesController < My::ApplicationController
  actions :create
  skip_authorization_check
  #custom_actions collection: :change_message_status

  def create
    create! do |success, failure|
      success.html { redirect_to my_dialog_path(@private_message.account)}
      failure.html { render partial: 'my/dialogs/form' }
    end
  end

  #def change_message_status
    #change_message_status! {
      #@private_message = PrivateMessage.find(params[:private_message_id])
      #@private_message.change_message_status

      #render partial: 'my/messages/message', locals: { message: @private_message } and return
    #}
  #end

  protected
  def begin_of_association_chain
    current_user.account
  end

  def build_resource
    @private_message = begin_of_association_chain.produced_messages.build(params[:private_message])
  end
end

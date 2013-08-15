class MessagesController < ApplicationController
  inherit_resources
  actions :index
  custom_actions collection: :change_message_status

  belongs_to :account, :optional => true

  def index
    index! {
      @messages = current_user.account.messages
    }
  end

  def change_message_status
    change_message_status! {
      @message = Message.find(params[:message_id])
      @message.change_message_status

      render partial: 'my/messages/message', locals: { message: @message } and return
    }
  end
end

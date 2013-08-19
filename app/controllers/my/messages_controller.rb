class My::MessagesController < My::ApplicationController
  inherit_resources
  actions :index
  custom_actions collection: :change_message_status

  belongs_to :account

  def index
    index! {
      render partial: 'my/messages/messages', locals: { messages: @messages }, layout: false and return
    }
  end

  def change_message_status
    change_message_status! {
      @message = Message.find(params[:message_id])
      @message.change_message_status

      render partial: 'my/messages/message', locals: { message: @message } and return
    }
  end

  private

  def collection
    @messages = super.page(params[:page]).per(5)
  end
end

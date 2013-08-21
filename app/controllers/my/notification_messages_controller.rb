class My::NotificationMessagesController < My::ApplicationController
  skip_authorization_check

  actions :index
  custom_actions collection: :change_message_status

  belongs_to :account

  def index
    index! {
      render partial: 'my/messages/messages', locals: { messages: @notification_messages }, layout: false and return
    }
  end

  def change_message_status
    change_message_status! {
      @notification_message = NotificationMessage.find(params[:notification_message_id])
      @notification_message.change_message_status

      render partial: 'my/messages/message', locals: { message: @notification_message } and return
    }
  end

  private

  def collection
    @notification_messages = super.page(params[:page]).per(5)
  end

  def begin_of_association_chain
    current_user.account
  end
end

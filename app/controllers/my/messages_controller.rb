class My::MessagesController < My::ApplicationController
  skip_authorization_check

  custom_actions resource: :change_message_status

  def change_message_status
    change_message_status! {
      @message.change_message_status

      render partial: 'my/messages/message', locals: { message: @message } and return
    }
  end
end

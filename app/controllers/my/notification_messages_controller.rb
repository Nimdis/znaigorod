class My::NotificationMessagesController < My::ApplicationController
  skip_authorization_check

  actions :index

  belongs_to :account

  def index
    index! {
      render partial: 'my/messages/messages', locals: { messages: @notification_messages }, layout: false and return
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

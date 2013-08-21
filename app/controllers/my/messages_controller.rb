class My::MessagesController < My::ApplicationController
  skip_authorization_check

  custom_actions collection: :change_message_status
end

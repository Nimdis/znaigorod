# encoding: utf-8

class NotificationMessage < Message
  attr_accessible :account, :body, :state, :kind, :producer, :messageable

  enumerize :kind, in: [:new_comment, :reply_on_comment, :afisha_published, :afisha_returned, :user_vote_afisha, :user_vote_comment, :user_visit_afisha, :user_add_friend]
end


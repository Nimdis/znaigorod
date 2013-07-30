# encoding: utf-8

class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    if comment.commentable.is_a?(Afisha)
      comment.messages.create(account: comment.is_root? ? comment.commentable.user.account : comment.parent.user.account,
                              user: comment.user,
                              body: comment.body,
                              kind: comment.is_root? ? :new_comment : :reply_on_comment)
    else
      comment.messages.create(account: nil,
                              user: comment.user,
                              body: comment.body,
                              kind: comment.is_root? ? :new_comment : :reply_on_comment)
    end
  end
end

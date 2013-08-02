# encoding: utf-8

class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    if comment.commentable.is_a?(Afisha)
      comment.messages.create(account: comment.is_root? ? (comment.commentable.user.present? ? comment.commentable.user.account : nil) : comment.parent.user.account,
                              producer_id: comment.user.account_id,
                              body: comment.body,
                              kind: comment.is_root? ? :new_comment : :reply_on_comment)
    else
      comment.messages.create(account: nil,
                              producer_id: comment.user.account_id,
                              body: comment.body,
                              kind: comment.is_root? ? :new_comment : :reply_on_comment)
    end
  end
end

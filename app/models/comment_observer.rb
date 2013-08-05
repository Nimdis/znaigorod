# encoding: utf-8

class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    if comment.commentable.is_a?(Afisha)
      if comment.is_root? && comment.commentable.user.present?
        comment.messages.create(account: comment.commentable.user.account, producer_id: comment.user.account_id, body: comment.body, kind: :new_comment)
      elsif comment.parent.present? && comment.user != comment.parent.user
        comment.messages.create(account: comment.parent.user.account, producer_id: comment.user.account_id, body: comment.body, kind: :reply_on_comment)
      end
    end
  end
end

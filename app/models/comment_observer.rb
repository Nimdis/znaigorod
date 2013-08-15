# encoding: utf-8

class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    if comment.commentable.is_a?(Afisha)
      if comment.is_root? && comment.commentable.user.present?
        Message.delay.create(
          account: comment.commentable.user.account,
          producer: comment.user.account,
          body: comment.body,
          kind: :new_comment,
          messageable: comment)
      elsif comment.parent.present? && comment.user != comment.parent.user
        Message.delay.create(
          account: comment.parent.user.account,
          producer: comment.user.account,
          body: comment.body,
          kind: :reply_on_comment,
          messageable: comment)
      end
    end
    comment.user.account.delay.update_rating
  end
end

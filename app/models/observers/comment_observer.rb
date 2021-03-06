# encoding: utf-8

class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    # уведомление об ответе на комментарий
    if comment.parent.present? && comment.user != comment.parent.user
      NotificationMessage.delay(:queue => 'critical').create(
        account: comment.parent.user.account,
        producer: comment.user.account,
        body: comment.body,
        kind: :reply_on_comment,
        messageable: comment)
    end
    # уведомление автору афиши о комментариях
    if comment.commentable.is_a?(Afisha) && comment.commentable.user && comment.commentable.user != comment.user
      NotificationMessage.delay(:queue => 'critical').create(
        account: comment.commentable.user.account,
        producer: comment.user.account,
        body: comment.body,
        kind: :new_comment,
        messageable: comment
      )
    end
  end
end

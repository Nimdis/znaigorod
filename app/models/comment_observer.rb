# encoding: utf-8

class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    comment.messages.create(body: "Добавлен новый комментарий: #{comment.body}",
                            account: comment.is_root? ? comment.commentable.user.account : comment.parent.user.account)
  end
end

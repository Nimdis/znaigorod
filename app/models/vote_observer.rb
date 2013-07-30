# encoding: utf-8

class VoteObserver < ActiveRecord::Observer
  def after_create(vote)
    if vote.voteable.is_a?(Afisha)
      vote.messages.create(body: "Ваша афиша нравится пользователю: #{vote.user.account}",
                           account: vote.voteable.user.present? ? vote.voteable.user.account : nil)
    elsif vote.voteable.is_a?(Comment)
      vote.messages.create(body: "Ваш комментарий нравится пользователю: #{vote.user.account}",
                           account: vote.voteable.user.account)
    end
  end
end

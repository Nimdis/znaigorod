# encoding: utf-8

class VoteObserver < ActiveRecord::Observer
  def after_create(vote)
    if vote.voteable.is_a?(Afisha) && vote.voteable.user.present? && vote.user.present?
      vote.messages.create(account: vote.voteable.user.account, producer_id: vote.user.account_id, kind: :user_vote_afisha)
    elsif vote.voteable.is_a?(Comment)
      vote.messages.create(account: vote.voteable.user.account, producer_id: vote.user.account_id, kind: :user_vote_comment)
    end
  end
end

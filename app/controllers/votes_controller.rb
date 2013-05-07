class VotesController < ApplicationController
  inherit_resources

  custom_actions :collection => :change_vote

  belongs_to :comment, :polymorphic => true, :optional => true
  belongs_to :organization, :polymorphic => true, :optional => true

  layout false

  def change_vote
    change_vote!{
      if current_user
        @vote = current_user.vote_for(parent).first || parent.votes.new(:user_id => current_user.id)
      else
        @vote = parent.votes.new
      end

      @vote.change_vote
      render :partial => 'vote', :locals => { :voteable => parent } and return
    }
  end
end

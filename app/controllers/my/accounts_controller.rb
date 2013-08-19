# encoding: utf-8

class My::AccountsController < My::ApplicationController
  def show
    @account = AccountDecorator.new(Account.find(current_user.account_id))
    @comments = @account.comments.rendereable.page(1).per(3)
    @events = @account.afisha.page(1).per(3)
    @messages = @account.messages.page(1).per(5)
    @votes = @account.votes.rendereable.page(1).per(3)
  end
end

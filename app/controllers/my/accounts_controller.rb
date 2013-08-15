# encoding: utf-8

class My::AccountsController < My::ApplicationController
  def show
    @account = AccountDecorator.new(Account.find(current_user.account_id))
  end
end

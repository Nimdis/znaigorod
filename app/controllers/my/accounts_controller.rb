# encoding: utf-8

class My::AccountsController < My::ApplicationController
  skip_authorization_check
  custom_actions :resource => [:destroy_image]

  def show
    @account = AccountDecorator.new(current_user.account)
    @comments = @account.comments.rendereable.page(1).per(3)
    @events = @account.afisha.page(1).per(3)
    @friends = Kaminari.paginate_array(@account.friends.approved.map(&:friendable)).page(1).per(5)
    @notification_messages = @account.notification_messages.page(1).per(5)
    @votes = @account.votes.rendereable.page(1).per(3)
    @dialogs = @account.dialogs
  end

  protected

  def resource
    @account ||= current_user.account
  end
end

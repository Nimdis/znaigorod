# encoding: utf-8

class My::AccountsController < My::ApplicationController
  custom_actions :resource => [:destroy_image]

  def show
    @account = AccountDecorator.new(Account.find(current_user.account_id))
    @comments = @account.comments.rendereable.page(1).per(3)
    @events = @account.afisha.page(1).per(3)
    @friends = Kaminari.paginate_array(@account.friends.approved.map(&:friendable)).page(1).per(5)
    @notification_messages = @account.notification_messages.page(1).per(5)
    @votes = @account.votes.rendereable.page(1).per(3)
  end

  def destroy_image
    destroy_image! {
      @account.avatar.destroy
      @account.save
      redirect_to edit_my_account_path(@account) and return
    }
  end
end

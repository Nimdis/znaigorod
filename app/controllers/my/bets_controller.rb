class My::BetsController < My::ApplicationController
  actions :create

  belongs_to :afisha

  custom_actions :resource => [:approve, :cancel]

  layout false

  skip_authorization_check

  def create
    create! { |success, failure|
      success.html { render @bet and return }
      failure.html { render :partial => 'form' and return }
    }
  end

  def approve
    approve! {
      @bet.approve!
      @message = @bet.notification_messages.find(params[:message_id])

      render :partial => 'my/messages/message', :locals => { :message => @message } and return
    }
  end

  def cancel
    cancel! {
      @bet.cancel!
      @message = @bet.notification_messages.find(params[:message_id])

      render :partial => 'my/messages/message', :locals => { :message => @message } and return
    }
  end

  protected

  def build_resource
    super.user = current_user

    @bet
  end
end

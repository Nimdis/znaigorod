class My::PrivateMessagesController < My::ApplicationController
  load_and_authorize_resource
  actions :create

  def new
    @private_message = begin_of_association_chain.produced_messages.new(account_id: params[:account_id])
    render partial: 'my/private_messages/form'
  end

  def create
    create! do |success, failure|
      success.html { redirect_to my_dialog_path(@private_message.account)}
      failure.html { render partial: 'my/private_messages/form' }
    end
  end

  protected

  def begin_of_association_chain
    current_user.account
  end

  def build_resource
    @private_message = begin_of_association_chain.produced_messages.build(params[:private_message])
  end
end

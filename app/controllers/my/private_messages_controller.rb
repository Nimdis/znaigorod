class My::PrivateMessagesController < My::ApplicationController
  load_and_authorize_resource

  actions :create, :new, :show
  custom_actions resource: :change_message_status

  layout false

  def new
    new! {
      @private_message.account_id = params[:account_id]
      if params[:afisha_id] || params[:organization_id]
        @source = if params[:afisha_id]
                    Afisha.find(params[:afisha_id])
                  elsif params[:organization_id]
                    Organization.find(params[:organization_id])
                  end
        @private_message.messageable = @source
        @private_message.invite_kind = params[:acts_as]
        @private_message.body = I18n.t("private_message.#{@source.class.name.underscore}.#{params[:acts_as]}_message", url: @source.is_a?(Afisha) ? afisha_show_url(@source) : organization_url(@source))
      else
        @dialog_with = Account.find(@private_message.account_id)
      end
      render partial: 'my/private_messages/form' and return
    }
  end

  def create
    create! do |success, failure|
      success.html { render @private_message }
      failure.html { render partial: 'my/private_messages/form' }
    end
  end

  def change_message_status
    change_message_status! {
      @private_message.change_message_status

      render partial: 'my/private_messages/private_message', locals: { message: @private_message } and return
    }
  end

  protected

  def begin_of_association_chain
    authorize! current_user, PrivateMessage.new(producer: current_user.try(:account))
    current_user.account
  end

  def build_resource
    @private_message = begin_of_association_chain.produced_messages.build(params[:private_message])
  end
end

class My::PrivateMessagesController < My::ApplicationController
  load_and_authorize_resource
  actions :create

  layout false
  respond_to :js, only: :create

  def new
    @source = Afisha.find(params[:afisha_id]) || Organization.find(params[:organization_id])
    @private_message = begin_of_association_chain.produced_messages.new(account_id: params[:account_id],
                                                                        messageable_id: @source.id,
                                                                        messageable_type: @source.class.name,
                                                                        invite_kind: params[:acts_as])
    if params[:afisha_id] || params[:organization_id]
      @private_message.body = I18n.t("private_message.#{params[:acts_as]}_message")
    end
    render partial: 'my/private_messages/form'
  end

  protected

  def begin_of_association_chain
    current_user.account
  end

  def build_resource
    @private_message = begin_of_association_chain.produced_messages.build(params[:private_message])
  end
end

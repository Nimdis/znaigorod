class My::PrivateMessagesController < My::ApplicationController
  load_and_authorize_resource
  actions :create, :new, :show

  layout false

  def new
    if params[:afisha_id] || params[:organization_id]
      @source = Afisha.find(params[:afisha_id]) || Organization.find(params[:organization_id])
      @private_message = begin_of_association_chain.produced_messages.new(account_id: params[:account_id],
                                                                          messageable_id: @source.id,
                                                                          messageable_type: @source.class.name,
                                                                          invite_kind: params[:acts_as])
      @private_message.body = I18n.t("private_message.#{params[:acts_as]}_message")
    else
      @private_message = begin_of_association_chain.produced_messages.new(account_id: params[:account_id])
      @dialog_with = Account.find(params[:account_id])
    end
    render partial: 'my/private_messages/form'
  end

  def create
    create!{
      render @private_message and return
    }
  end

  protected

  def begin_of_association_chain
    current_user.account
  end

  def build_resource
    @private_message = begin_of_association_chain.produced_messages.build(params[:private_message])
  end
end

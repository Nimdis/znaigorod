class Crm::ContactsController < Crm::ApplicationController

  actions :all, :except => [:show]
  belongs_to :organization

  def destroy
    destroy! { render :index and return }
  end

end

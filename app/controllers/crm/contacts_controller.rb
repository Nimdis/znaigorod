class Crm::ContactsController < Crm::ApplicationController

  actions :all, :except => [:show]
  belongs_to :organization

  layout :determine_layout

  def destroy
    destroy! { render :index and return }
  end

  private

    def determine_layout
      request.xhr? ? false : 'crm'
    end

end

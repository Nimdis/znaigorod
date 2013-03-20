class Crm::ContactsController < Crm::ApplicationController
  actions :all, :except => [:show]
  belongs_to :organization

  layout :determine_layout

  private

    def determine_layout
      request.xhr? ? false : 'crm'
    end

end

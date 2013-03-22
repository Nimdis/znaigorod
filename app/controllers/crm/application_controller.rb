class Crm::ApplicationController < Manage::ApplicationController

  layout :determine_layout

  private

    def determine_layout
      request.xhr? ? false : 'crm'
    end

end

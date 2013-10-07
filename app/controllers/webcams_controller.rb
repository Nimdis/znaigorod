class WebcamsController < ApplicationController

  inherit_resources

  actions :index, :show

  has_scope :published, :type => :boolean, :default => true

  caches_page :index

  def show
    show! {
      @tickets = Ticket.available.sort {|a, b| rand <=> rand }[0..4]
      is_ie = cookies['_show_webcam_in_ie'].to_s
      cookies.delete '_show_webcam_in_ie'
      if (is_ie == 'true') ||
        (request.referrer.present? && request.referrer.match(root_url) &&
        Rails.application.routes.recognize_path(request.referrer)[:controller] == 'webcams' &&
        Rails.application.routes.recognize_path(request.referrer)[:action] == 'index')
        @layout_name = 'webcam'
        render :layout => 'webcam' and return
      else
        @layout_name = 'public'
      end
    }
  end

end

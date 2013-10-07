# encoding: utf-8

module MakePageVisit
  extend ActiveSupport::Concern

  def create_page_visit(session, user_agent, user)
    page_visit = self.page_visits.new
    page_visit.user_agent = user_agent.to_s.encode('UTF-8', :undef => :replace, :invalid => :replace, :replace => '')
    page_visit.user = user
    page_visit.save
  end
end

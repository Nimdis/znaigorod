# encoding: utf-8

class TicketObserver < ActiveRecord::Observer
  def after_save(ticket)
    ticket.afisha.delay.reindex_showings
    #user.delay.get_friends_from_socials
  end
end

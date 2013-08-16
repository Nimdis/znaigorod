# encoding: utf-8

class CopyObserver < ActiveRecord::Observer
  def after_save(copy)
    if copy.copyable.is_a?(Ticket)
      copy.copyable.afisha.delay.reindex_showings
      copy.copyable.afisha.delay.update_rating
    end
  end
end

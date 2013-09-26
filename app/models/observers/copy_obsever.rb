# encoding: utf-8

class CopyObserver < ActiveRecord::Observer
  def after_save(copy)
    if copy.copyable.is_a?(Ticket)
       copy.copyable.afisha.delay.reindex_showings
    end
  end
end

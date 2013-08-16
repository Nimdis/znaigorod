# encoding: utf-8

class ShowingObserver < ActiveRecord::Observer
  def after_save(showing)
    showing.afisha.delay.index
  end

  def after_destroy(showing)
    showing.afisha.delay.index
  end
end

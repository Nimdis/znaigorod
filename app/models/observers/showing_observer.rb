# encoding: utf-8

class ShowingObserver < ActiveRecord::Observer
  def after_save(showing)
    showing.afisha.delay.index
    showing.organization.delay.update_rating if showing.organization
  end

  def after_destroy(showing)
    showing.afisha.delay.index
    showing.organization.delay.update_rating if showing.organization
  end
end

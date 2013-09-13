# encoding: utf-8

class PageVisitObserver < ActiveRecord::Observer
  def after_save(page_visit)
    #page_visit.user.account.delay.update_rating if page_visit.user

    # TODO uncommented when search bots will be ignored
    #page_visit.page_visitable.delay.update_rating if page_visit.page_visitable.respond_to?(:update_rating)
  end
end

# encoding: utf-8

class SuborganizationObserver < ActiveRecord::Observer
  observe :meal
  #def after_save(record)
    #record.organization.delay.update_rating
    #record.organization.delay.update_slave_organization_statuses
    #record.organization.delay.index_suborganizations
  #end
end

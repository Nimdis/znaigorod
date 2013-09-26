# encoding: utf-8

class SuborganizationObserver < ActiveRecord::Observer
  observe :billiard, :car_sales_center, :car_service_center, :car_wash,
    :creation, :culture, :entertainment, :hotel, :meal, :salon_center, :sauna,
    :sport, :travel
  def after_save(record)
    record.organization.delay.update_slave_organization_statuses
    record.organization.delay.index_suborganizations
  end
end

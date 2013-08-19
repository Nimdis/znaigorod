# encoding: utf-8

class OrganizationObserver < ActiveRecord::Observer
  cattr_accessor :disabled
  def after_save(organization)
    return if OrganizationObserver.disabled
    organization.delay.update_rating
    organization.delay.update_slave_organization_statuses
    organization.delay.index_suborganizations
  end
end

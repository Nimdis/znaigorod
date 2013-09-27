# encoding: utf-8

class OrganizationObserver < ActiveRecord::Observer
  cattr_accessor :disabled
  def after_save(organization)
    return if OrganizationObserver.disabled
    organization.delay(:queue => 'critical').upload_poster_to_vk if (organization.poster_vk_id.nil? || organization.logotype_url_changed?) && organization.logotype_url?
    organization.delay.update_slave_organization_statuses
    organization.delay.index_suborganizations
  end
end

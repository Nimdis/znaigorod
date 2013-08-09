# encoding: utf-8

class SaunasPresenter
  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :sauna, filters: [:categories]

  def categories_filter
    Hashie::Mash.new(available: ['сауны'])
  end

  def pluralized_kind
    'saunas'
  end
end

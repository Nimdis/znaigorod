# encoding: utf-8

class AfishaCounter
  include ActiveAttr::MassAssignment

  attr_accessor :category, :organization, :period, :date

  def count
    case period
    when 'daily'
      searcher.groups.group(:afisha_id_str).total
    when 'all'
      searcher.actual.groups.group(:afisha_id_str).total
    else
      searcher.send(period).actual.groups.group(:afisha_id_str).total
    end
  end

  private

  def searcher_params
    {}.tap {|hash|
      hash[:categories] = [category] if category.present?
      hash[:starts_on] = date if date.present? && period == 'daily'
    }
  end

  def searcher
    @searcher ||= HasSearcher.searcher(:showings, searcher_params)
  end
end

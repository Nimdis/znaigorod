# encoding: utf-8

class Counter
  include ActiveAttr::MassAssignment

  attr_accessor :category, :organization

  def today
    @today ||= searcher.today.actual.groups.group(:afisha_id_str).total
  end

  def weekend
    @weekend ||= searcher.weekend.actual.groups.group(:afisha_id_str).total
  end

  def week
    @week ||= searcher.week.actual.groups.group(:afisha_id_str).total
  end

  def all
    @all ||= searcher.actual.groups.group(:afisha_id_str).total
  end

  private

  def searcher_params
    {}.tap {|hash|
      hash[:categories] = [category] if category.present?
    }
  end

  def searcher
    @searcher ||= HasSearcher.searcher(:showings, searcher_params)
  end
end

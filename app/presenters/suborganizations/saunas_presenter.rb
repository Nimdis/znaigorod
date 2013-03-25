# encoding: utf-8

class SaunasPresenter
  def categories_filter
    Hashie::Mash.new(available: ['сауны'])
  end

  def pluralized_kind
    'saunas'
  end
end

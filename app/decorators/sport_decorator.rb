# encoding: utf-8

class SportDecorator < CreationDecorator
  decorates :sport

  def title
    sport.title? ? sport.title : 'Спорт'
  end
end

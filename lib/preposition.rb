# encoding: utf-8

class Preposition
  def initialize(item)
    @item = item
  end

  def value
    return 'на' if @item.is_a?(Afisha)
    return 'в' if @item.is_a?(Organization)
  end
end

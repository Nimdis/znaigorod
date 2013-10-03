class FromRussianToParam
  def self.convert(text)
    Russian.translit(text).underscore.gsub(" ", "_")
  end
end

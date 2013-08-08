AutoHtml.add_filter(:double_enter) do |text|
  text.gsub(/\n+/, "\n").gsub(/\n/, "\n\n")
end

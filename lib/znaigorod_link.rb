require 'rinku'
require 'rexml/document'
raise 'aaaaa'.inspect

AutoHtml.add_filter(:znaigorod_link).with({}) do |text, options|
  attributes = Array(options).reject { |k,v| v.nil? }.map { |k, v| %{#{k}="#{REXML::Text::normalize(v)}"} }.join(' ')
  Rinku.auto_link(text, :all, attributes) do |url|
    "znaigorod_link"
  end
end

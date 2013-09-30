require 'gilenson'
require 'redcloth'
require 'rexml/document'
require 'rinku'

AutoHtml.add_filter(:redcloth).with({}) do |text, options|
  attributes = Array(options).reject { |k,v| v.nil? }.map { |k, v| %{#{k}="#{REXML::Text::normalize(v)}"} }.join(' ')
  result = RedCloth.new(text).to_html
  result = Rinku.auto_link(result, :all, attributes)
  result = Gilenson.new(result).to_html.html_safe
  result.gsub!(/<a/,'<a target="_blank"') if options and options[:target] and options[:target].to_sym == :_blank
  result.gsub!(/<a/,'<a rel="nofollow"') if options and options[:rel] and options[:rel].to_sym == :nofollow

  result
end

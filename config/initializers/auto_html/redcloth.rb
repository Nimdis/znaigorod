require 'gilenson'
require 'redcloth'

AutoHtml.add_filter(:redcloth).with({}) do |text, options|
  result = Gilenson::RedClothExtra.new(text).to_html.html_safe
  if options and options[:target] and options[:target].to_sym == :_blank
    result.gsub!(/<a/,'<a target="_blank"')
  end
  if options and options[:rel] and options[:rel].to_sym == :nofollow
    result.gsub!(/<a/,'<a rel="nofollow"')
  end
  result
end

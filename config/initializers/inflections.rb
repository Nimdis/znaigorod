# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end
#
# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.acronym 'RESTful'
# end

ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'sms', 'smses'
  inflect.irregular 'affiche', 'affiches'

  inflect.singular 'address',       'address'
  #inflect.singular 'affiches',      'affiche'
  #inflect.singular 'master_class',  'master_class'
  inflect.singular 'masterclass',   'masterclass'
  inflect.singular 'masterclasses', 'masterclass'
end

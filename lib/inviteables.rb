require 'singleton'

class Inviteables
  include Singleton

  attr_reader :categories

  def initialize
    @categories = Hashie::Mash.new(YAML.load_file(Rails.root.join('config', 'inviteables.yml')))
  end

  def categories_for_organization(organization)
    categories.select { |key, value|
      value_organization_categories = value.organization.categories.map(&:mb_chars).map(&:downcase).map(&:to_s)

      if value_organization_categories.any?
        (value.organization.suborganizations & organization.suborganizations.map(&:class).map(&:name).map(&:underscore)).any? &&
          (value_organization_categories & [*organization.category].map(&:mb_chars).map(&:downcase).map(&:to_s)).any?
      else
        (value.organization.suborganizations & organization.suborganizations.map(&:class).map(&:name).map(&:underscore)).any?
      end
    }.keys
  end

  def categories_for_afisha(afisha)
    categories.select { |key, value|
      (value.afisha.kinds & afisha.kind.values.to_a).any?
    }.keys
  end
end

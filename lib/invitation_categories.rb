require 'singleton'

class InvitationCategories
  include Singleton

  attr_reader :invitation_categories

  def initialize
    @invitation_categories = Hashie::Mash.new(YAML.load_file(Rails.root.join('config', 'invitation_categories.yml')))
  end

  def categories_for_organization(organization)
    invitation_categories.select { |key, value|
      (value.organization.suborganizations & organization.suborganizations.map(&:class).map(&:name).map(&:underscore)).any? &&
        (value.organization.categories.map(&:mb_chars).map(&:downcase).map(&:to_s) & [*organization.category].map(&:mb_chars).map(&:downcase).map(&:to_s)).any?
    }.keys
  end

  def categories_for_afisha(afisha)
    invitation_categories.select { |key, value|
      (value.afisha.kinds & afisha.kind.values.to_a).any?
    }.keys
  end
end

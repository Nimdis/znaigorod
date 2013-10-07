# encoding: utf-8

require 'singleton'

class Values
  include Singleton

  attr_reader :values

  def initialize
    @values = Hashie::Mash.new(YAML.load_file(Rails.root.join('config', 'values.yml')))

    @values[:invitation] = {}
    @values[:invitation][:categories] = Hashie::Mash.new(YAML.load_file(Rails.root.join('config', 'inviteables.yml'))).keys
  end

  delegate *Organization.available_suborganization_kinds, to: :values
  delegate :invitation, to: :values
end

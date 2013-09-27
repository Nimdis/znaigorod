# encoding: utf-8

require 'singleton'

class Values
  include Singleton

  attr_reader :values

  def initialize
    @values = Hashie::Mash.new(YAML.load_file(Rails.root.join('config', 'values.yml')))
  end

  delegate *Organization.available_suborganization_kinds, to: :values
end

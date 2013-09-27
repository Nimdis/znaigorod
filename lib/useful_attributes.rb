# encoding: utf-8

module UsefulAttributes
  extend ActiveSupport::Concern

  module ClassMethods
    attr_accessor :exclude

    def use_attributes(*args)
      options = args.extract_options!

      self.exclude = options[:exclude]
    end
  end

  def useful_attributes
    self.attributes.keys.delete_if { |key| key =~ exclude_regexp }
  end

  private

  def excluded_attributes
    %w[id created_at updated_at vfs_path] + [*self.class.exclude]
  end

  def exclude_regexp
    Regexp.new "(#{excluded_attributes.join('|')})"
  end
end

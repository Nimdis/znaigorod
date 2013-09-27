# encoding: utf-8

module PresentsAsCheckboxes
  extend ActiveSupport::Concern

  module ClassMethods
    def presents_as_checkboxes(*args)
      options = args.extract_options!
      field = args.first

      attr_accessor "#{field}_list"
      attr_accessible "#{field}_list"

      define_method "available_#{field.to_s.pluralize}" do
        case options[:available_values]
        when Array
          options[:available_values]
        when Proc
          options[:available_values].call
        else
          Values.instance.send(self.class.name.underscore).send(field.to_s.pluralize)
        end
      end

      define_method "normalize_#{field}_list" do
        self.send "#{field}_list=", [*options[:default_value]] if options[:default_value]

        self.send "#{field}_list=", [*self.send("#{field}_list")].delete_if(&:blank?)
      end

      define_method "set_#{field}" do
        self.send "#{field}=", self.send("#{field}_list").join(', ')
      end

      before_validation "normalize_#{field}_list"
      before_validation "set_#{field}"

      define_method field.to_s.pluralize do
        (self.send(field) || '').split(',').map(&:squish)
      end

      if options[:validates_presence]
        message = options[:message] || I18n.t('activerecord.errors.messages.blank')
        validates_presence_of "#{field}_list", :message => message
      end
    end
  end
end

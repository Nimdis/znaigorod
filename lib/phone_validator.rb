# encoding: utf-8

class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    values = value.split(',').map(&:squish)
    invalid_values = values.select { |v| !valid?(v) }
    record.errors[attribute] << invalid_values.map { |v| "#{v} #{I18n.t('activerecord.errors.messages.invalid')}"}.join(', ') if invalid_values.any?

    normalize_value(record, attribute, value)
  end

  def valid?(value)
    return false if value =~ /[[:alpha]]/
    return true if value =~ /^\d{3}$/

    !!regexp.match(value)
  end

  def regexp
    /(\(3822\)\s)?\d{2}-\d{2}-\d{2}|\d{3}-\d{3}|8-\d{3}-\d{3}-\d{2}-\d{2}/
  end

  def normalize_value(record, attribute, value)
    values = value.split(',').map(&:squish)
    record.send("#{attribute}=", values.join(', '))
  end
end

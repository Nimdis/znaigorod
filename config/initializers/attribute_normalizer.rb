AttributeNormalizer.configure do |config|
  config.normalizers[:as_array_of_integer] = ->(value, options) do
    value.reject { |e| e.blank? }.map(&:to_i)
  end

  config.normalizers[:strip_array] = ->(value, options) do
    value.squish.split(/\s/).uniq
  end

  config.normalizers[:blank_array] = ->(value, options) do
    value.try(:detect, &:present?) ? value : nil
  end
end


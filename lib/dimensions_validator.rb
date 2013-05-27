# encoding: utf-8

class DimensionsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.send("#{attribute}_file_name?")
      min_width, min_height = options[:width_min], options[:height_min]
      dimensions = value.queued_for_write[:original].try(:path).blank? ? Paperclip::Geometry.new : Paperclip::Geometry.from_file(value.queued_for_write[:original].path)
      record.errors[attribute] << (options[:message] || "Ширина должна быть не менее #{min_width} пикселей") if dimensions.width < min_width
      record.errors[attribute] << (options[:message] || "Высота должна быть не менее #{min_height} пикселей") if dimensions.height < min_height
    end
  end
end

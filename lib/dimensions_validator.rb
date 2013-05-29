# encoding: utf-8

class DimensionsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.send("#{attribute}_file_name?")
      min_width, min_height = options[:width_min], options[:height_min]

      if value.queued_for_write[:original].try(:path).blank? || record.send("#{attribute}_content_type").match(/image/).nil?
        dimensions = Paperclip::Geometry.new
      else
        dimensions = Paperclip::Geometry.from_file(value.queued_for_write[:original].path)
      end

      record.errors[attribute] << (options[:message] || "Ширина должна быть не менее #{min_width} пикселей") if dimensions.width < min_width
      record.errors[attribute] << (options[:message] || "Высота должна быть не менее #{min_height} пикселей") if dimensions.height < min_height
    end
  end
end

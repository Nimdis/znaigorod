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

module Paperclip
  class Geometry
    def self.from_file file
      file_path = (file.respond_to?(:path) ? file.path : file) #.gsub(/\s/, '\\\\\1')
      raise(Errors::NotIdentifiedByImageMagickError.new("Cannot find the geometry of a file with a blank name")) if file_path.blank?
      geometry = begin
        silence_stream(STDERR) do
          Paperclip.run("identify", "-format %wx%h :file", :file => file_path)
        end
      rescue Cocaine::ExitStatusError
        ""
      rescue Cocaine::CommandNotFoundError => e
        raise Errors::CommandNotFoundError.new("Could not run the `identify` command. Please install ImageMagick.")
      end
      parse(geometry) ||
          raise(Errors::NotIdentifiedByImageMagickError.new("#{file_path} is not recognized by the 'identify' command. (from #{file.inspect})"))
    end
  end

  class Thumbnail
    def make
      src = @file
      dst = Tempfile.new([@basename, @format ? ".#{@format}" : ''])
      dst.binmode

      begin
        parameters = []
        parameters << source_file_options
        parameters << ":source"
        parameters << transformation_command
        parameters << convert_options
        parameters << ":dest"

        parameters = parameters.flatten.compact.join(" ").strip.squeeze(" ")

        success = convert(parameters, :source => "#{File.expand_path(src.path)}#{'[0]' if animated?}", :dest => File.expand_path(dst.path))
      rescue Cocaine::ExitStatusError => e
        raise Paperclip::Error, "There was an error processing the thumbnail for #{@basename}" if @whiny
      rescue Cocaine::CommandNotFoundError => e
        raise Paperclip::Errors::CommandNotFoundError.new("Could not run the `convert` command. Please install ImageMagick.")
      end

      dst
    end

    protected

    def identified_as_animated?
      ANIMATED_FORMATS.include? identify("-format %m :file", :file => "#{@file.path}[0]").to_s.downcase.strip
    rescue Cocaine::ExitStatusError => e
      #raise Paperclip::Error, "There was an error running `identify` for #{@basename}" if @whiny
      return false
    rescue Cocaine::CommandNotFoundError => e
      raise Paperclip::Errors::CommandNotFoundError.new("Could not run the `identify` command. Please install ImageMagick.")
    end
  end
end

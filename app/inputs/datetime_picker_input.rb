class DatetimePickerInput < SimpleForm::Inputs::StringInput
  def input_html_classes
    super.push('datetime_picker')
  end

  def input
    @builder.text_field(attribute_name, input_html_options.merge(datetime_picker_options(object.send(attribute_name))))
  end

  def datetime_picker_options(value = nil)
    datetime_picker_options = {:value => value.nil?? nil : I18n.localize(value)}
  end
end

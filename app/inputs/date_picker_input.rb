class DatePickerInput < SimpleForm::Inputs::StringInput
  def input_html_classes
    super.push('date_picker')
  end

  def input
    @builder.text_field(attribute_name, input_html_options.merge(date_picker_options(object.send(attribute_name))))
  end

  def date_picker_options(value = nil)
    date_picker_options = {:value => value.nil?? nil : I18n.localize(value)}
  end
end

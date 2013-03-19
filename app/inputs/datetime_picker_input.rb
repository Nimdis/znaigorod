class DatetimePickerInput < SimpleForm::Inputs::StringInput
  def input_html_classes
    super.push('datetime_picker')
  end
end

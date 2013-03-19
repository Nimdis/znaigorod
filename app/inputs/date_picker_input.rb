class DatePickerInput < SimpleForm::Inputs::StringInput
  def input_html_classes
    super.push('datepicker')
  end
end

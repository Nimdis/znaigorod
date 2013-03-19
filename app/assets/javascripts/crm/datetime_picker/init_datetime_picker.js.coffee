@init_datetime_picker = () ->
  $('input.datetime_picker').datetimepicker
    buttonImage: '/assets/crm/ui-calendar.png'
    buttonImageOnly: true
    buttonText: 'выбрать'
    changeMonth: true
    changeYear: true
    showOn: 'button',
    showOtherMonths: true
  true

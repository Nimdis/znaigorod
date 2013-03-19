@init_date_picker = () ->
  $('input.date_picker').datepicker
    buttonImage: '/assets/crm/ui-calendar.png'
    buttonImageOnly: true
    buttonText: 'выбрать'
    changeMonth: true
    changeYear: true
    showOn: 'button',
    showOtherMonths: true
  true

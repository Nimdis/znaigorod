@init_datetime_picker = () ->
  $('input.date_picker').datetimepicker()
  $('form').on('nested:fieldAdded', (event) ->
    $(event.field).find('input.date_picker').removeClass('hasDatepicker').datetimepicker()
  )

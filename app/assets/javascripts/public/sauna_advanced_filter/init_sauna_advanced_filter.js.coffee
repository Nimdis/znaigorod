@init_sauna_advanced_filter = () ->
  toggler = $('.filters_wrapper .advanced_filters_toggler a')

  toggler.click ->
    $('.advanced', $(this).closest('.filters_wrapper')).slideToggle 400, ->
      if $('.advanced', $(this).closest('.filters_wrapper')).is(':visible')
        toggler.html('&uarr; Расширенный поиск')
      else
        toggler.html('&darr; Расширенный поиск')
      true
    false

  true

@init_additional_info = () ->
  additional_info_wrapper = $('.additional_info_wrapper')
  return unless additional_info_wrapper.length
  toggle_link = $('.toggle_link', additional_info_wrapper)

  toggle_link.on 'click', ->
    $('.inner_wrapper', additional_info_wrapper).slideToggle ->
      if $(this).is(':visible') then toggle_link.text('Свернуть') else toggle_link.text('Подробнее')
    false

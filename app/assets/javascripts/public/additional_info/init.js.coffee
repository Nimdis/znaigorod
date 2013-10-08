@init_additional_info = () ->
  additional_info_wrapper = $('.additional_info_wrapper')
  return unless additional_info_wrapper.length
  toggle_link = $('.toggle_link', additional_info_wrapper)

  toggle_link.on 'click', ->
    return  false if toggle_link.hasClass('fired')
    toggle_link.addClass('fired')
    $('.inner_wrapper', additional_info_wrapper).slideToggle ->
      if $(this).is(':visible') then toggle_link.text('Свернуть') else toggle_link.text('Подробнее')
      toggle_link.removeClass('fired')
    false

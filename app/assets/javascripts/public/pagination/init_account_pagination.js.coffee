scroll = (target) ->
  y_coord = Math.abs($(window).height() - target.offset().top - 200)
  $("html, body").animate({ scrollTop: y_coord })

recalculate_block_height = (kind, limit = 0) ->
  prev_element_top = $('li:first', kind).position().top
  block_height = $('li:first', kind).outerHeight(true, true)
  $('ul li', kind).each (index) ->
    if $(this).position().top > prev_element_top
      prev_element_top = $(this).position().top
      block_height += $(this).outerHeight(true, true)
    return false if limit > 0 && (limit - 1) == index
    true
  block_height

more_handler = (kind, response) ->
  kind.css('height', recalculate_block_height(kind))
  wrapped = $("<div>#{response}</div>")
  $('ul', kind).append($('ul', wrapped).html())
  $('.pagination:last', kind).hide()
  $('.pagination', kind).after($('.pagination', wrapped))
  wrapped.remove()
  kind.animate
    height: recalculate_block_height(kind)
    , 300, ->
      $('.pagination:first', kind).remove()
      $('.pagination:last', kind).show()
      scroll($('.pagination', kind))
      true

  process_change_message_status()

  true

collapse_handler = (kind) ->
  min_height = recalculate_block_height(kind, 3)

  kind.animate
    height: min_height
    , 300, ->
      $('ul li', kind).each (index) ->
        $(this).remove() if index > 2
        true
      replaced_href = $('.next_page', kind).attr('href').replace(/page=\d+/, 'page=2')
      $('.next_page', kind).attr('href', replaced_href).removeClass('disabled')
      $('.toggler', kind).addClass('disabled')
      scroll($('.pagination', kind))
      true

  false

  #delimiter

@init_account_pagination = () ->
  $('.next_page').live 'ajax:beforeSend', (xhr, settings) ->
    return false if $(this).hasClass('disabled')
    true

  $('.next_page').live 'ajax:success', (event, response, status, xhr) ->
    list = $(event.target).closest('.list')
    tab = $(event.target).closest('.ui-widget-content')

    if tab.length
      more_handler(tab, response)
    if list.length
      more_handler(list, response)

  $('.toggler').live 'click', (event) ->
    return false if $(this).hasClass('disabled')
    list = $(event.target).closest('.list')
    tab = $(event.target).closest('.ui-widget-content')

    if tab.length
      collapse_handler(tab)
    if list.height
      collapse_handler(list)

    false

  true

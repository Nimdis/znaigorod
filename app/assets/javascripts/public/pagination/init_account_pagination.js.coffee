@init_account_pagination = () ->

  scroll = (target) ->
    y_coord = Math.abs($(window).height() - target.offset().top - 200)
    $("html, body").animate({ scrollTop: y_coord })

    true

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
    unless $('li.delimiter', kind).length
      $('li:last', kind).addClass('delimiter')

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

    delimiter_index = $('li.delimiter', kind).index()

    min_height = recalculate_block_height(kind, delimiter_index + 1)

    kind.animate
      height: min_height
      , 300, ->
        $('ul li', kind).each (index) ->
          $(this).remove() if index > delimiter_index
          true
        replaced_href = $('.next_page', kind).attr('href').replace(/page=\d+/, 'page=2')
        $('.next_page', kind).attr('href', replaced_href).removeClass('disabled')
        $('.toggler', kind).addClass('disabled')
        scroll($('.pagination', kind))
        true

    false

  $('.content .account_show .right .next_page').live 'click', (event) ->
    link = $(this)
    return false if link.hasClass('disabled')

    $.ajax
      url: link.attr('href')
      success: (response, textStatus, jqXHR) ->
        more_handler(link.closest('.list'), response)
        true

    false

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

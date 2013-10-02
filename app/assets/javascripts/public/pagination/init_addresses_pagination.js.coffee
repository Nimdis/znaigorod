@init_addresses_pagination = (map) ->
  page = 1
  busy = false
  list = $('.result_list')
  pagination = $('.pagination')
  next_link = $('.next a', pagination)

  list.jScrollPane
    autoReinitialise: true
    verticalGutter: 0
    showArrows: true
    mouseWheelSpeed: 30

  block_offset = $('li:last', list).outerHeight(true, true) * ($('li', list).length - 3) - $('.jspContainer', list).outerHeight(true, true)
  if next_link.length
    list.bind 'jsp-scroll-y', (event, scrollPositionY, isAtTop, isAtBottom) ->
      if block_offset < scrollPositionY && !busy
        busy = true
        $.ajax
          url: next_link.attr('href')
          success: (response, textStatus, jqXHR) ->
            return true if (typeof next_link.attr('href')) == 'undefined'
            $("#{response}").find('.result_list .show_map_link').each (index, item) ->
              add_point_on_side_map(item, map)
              true
            list = $("#{response}").find('.result_list').children()
            $('.jspPane', event.target).append(list)
            block_offset = $('li:last', event.target).outerHeight(true, true) * ($('li', event.target).length - 30) - $('.jspContainer', list).outerHeight(true, true)
            busy = false
            pagination.html($('.pagination', response).html())
            next_link = $('.next a', pagination)
            page++
            true
        true
    true


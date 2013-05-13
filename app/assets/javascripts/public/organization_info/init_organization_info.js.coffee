@init_organization_info = () ->
  $('.organization_info .info .description, .organization_info .sauna_hall_description').each (index, item) ->
    block = $(this)
    block_height = block.outerHeight(true)
    max_height = 26
    if block.height() > max_height
      block.height(max_height)
      $('<a href=\'#\' class=\'toggler closed\'>развернуть</a>').prependTo(block)
    $('a.toggler', block).click (event) ->
      $(this).toggleClass('closed').toggleClass('opened')
      if $(this).hasClass('opened')
        $(this).text('свернуть')
        block.stop(true, true).animate
          height: block_height
        , 'fast'
      if $(this).hasClass('closed')
        $(this).text('развернуть')
        block.stop(true, true).animate
          height: max_height
        , 'fast'
      false
    true

  true

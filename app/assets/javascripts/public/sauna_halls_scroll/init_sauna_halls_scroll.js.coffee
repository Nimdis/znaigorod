@init_sauna_halls_scroll = () ->

  $('.organizations_list .sauna_halls').jScrollPane
     verticalGutter: 2
     showArrows: true
     mouseWheelSpeed: 10

  $('.organizations_list .sauna_halls').each (index, item) ->
    return true unless $('li.non_suitable', $(this)).length
    $('li.non_suitable', $(this)).appendTo($('li.non_suitable:first', $(this)).parent())
    true

  true

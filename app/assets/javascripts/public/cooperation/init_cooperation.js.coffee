@init_cooperation = ->

  $('.cooperation .toggler a').each ->
    link = $(this)
    link.click ->
      $('.info', $(this).closest('.toggable')).slideToggle 'fast', ->
        if $('.info', $(this).closest('.toggable')).is(':visible')
          link.html('&uarr; свернуть')
        else
          link.html('&darr; развернуть')
        true
      false
    true

  $('.cooperation .toggable .info:first').show()

  poster = $('.cooperation a img')
  poster.each (index, item) ->
    $(item).closest('a').colorbox
      'close': 'закрыть'
      'current': '{current} / {total}'
      'maxHeight': '98%'
      'maxWidth': '90%'
      'next': 'следующая'
      'opacity': '0.6'
      'photo': 'true'
      'previous': 'предыдущая'
    true

  true

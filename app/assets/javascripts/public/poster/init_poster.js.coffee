@init_poster = () ->
  poster = $('.content .left .image a img')
  return true if poster.hasClass('stub')
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

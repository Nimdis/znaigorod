@init_photogallery = () ->
  $('.photogallery ul').jcarousel
    scroll: 4
    visible: 5
  $('.photogallery a').colorbox
    'close': 'закрыть'
    'current': '{current} / {total}'
    'maxHeight': '98%'
    'maxWidth': '90%'
    'next': 'следующая'
    'opacity': '0.6'
    'photo': 'true'
    'previous': 'предыдущая'
  true

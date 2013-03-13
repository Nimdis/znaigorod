@init_included_photos = () ->
  if $('.photogallery').closest('.organization_info').length
    scroll = 5
    visible = 6
  if $('.photogallery').closest('.post').length
    scroll = 3
    visible = 4
  $('.photogallery ul').jcarousel
    scroll: scroll
    visible: visible
  $('.photogallery a').colorbox
    'maxWidth': '90%'
    'maxHeight': '98%'
    'photo': 'true'
    'current': '{current} / {total}'
    'previous': 'предыдущая'
    'next': 'следующая'
    'close': 'закрыть'
  true

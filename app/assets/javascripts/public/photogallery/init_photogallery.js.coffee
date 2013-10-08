@init_photogallery = () ->

  scroll_count = 4
  visible_count = 5

  if $('.photogallery').closest('.post_show').length
    scroll_count = 5
    visible_count = 6

  $('.photogallery ul').jcarousel
    scroll: scroll_count
    visible: visible_count

  $('.photogallery a').colorbox
    close: 'закрыть'
    current: '{current} из {total}'
    maxHeight: '90%'
    maxWidth: '90%'
    next: 'следующая'
    opacity: '0.5'
    photo: 'true'
    previous: 'предыдущая'
    title: ->
      $(this).attr('title') || $('img', this).attr('alt') || '&nbsp;'

  true

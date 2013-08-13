@init_photogallery = () ->

  $('.photogallery ul').jcarousel
    scroll: 4
    visible: 5

  $('.photogallery a').attr('rel', 'gal').colorbox
    close: 'закрыть'
    current: '{current} из {total}'
    maxHeight: '98%'
    maxWidth: '90%'
    next: 'следующая'
    opacity: '0.5'
    photo: 'true'
    previous: 'предыдущая'
    title: ->
      $(this).attr('title') || $('img', this).attr('alt') || '&nbsp;'

  true

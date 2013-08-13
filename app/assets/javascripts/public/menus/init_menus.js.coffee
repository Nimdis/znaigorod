@init_menus = () ->
  $('.menus .info .value a').on 'click', ->
    link = $(this)
    info = link.closest('.info')
    if $('.form_view', info).length && $('.details', info).is(':hidden')
      return false
    link.toggleClass('opened').toggleClass('closed')
    $('.details', link.closest('li')).slideToggle('fast')
    if link.hasClass('opened')
      link.text('свернуть')
    if link.hasClass('closed')
      link.text('развернуть')
    false

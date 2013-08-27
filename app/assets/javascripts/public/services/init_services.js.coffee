@init_services = () ->
  $('.services .info a').live 'click', ->
    link = $(this)
    link.toggleClass('opened').toggleClass('closed')
    $('.details', link.closest('.info')).slideToggle('fast')
    if link.hasClass('opened')
      link.text('свернуть')
    if link.hasClass('closed')
      link.text('подробнее')
    false

  $('.services .info .multi_price abbr').tipsy() if $.fn.tipsy

  true

@init_more_main_menu = () ->
  link = $('.filters .by_categories .more_link')
  block = $('.filters_wrapper .more')

  link.addClass('selected') if $('.selected', block).length

  block.css
    left: link.position().left - link.outerWidth(true, true) + 15
    top: link.position().top + link.outerHeight() - 20

  link.click ->
    block.toggle()
    block.addClass('need_close_by_click')
    false
  true

$(document).click ->
  $(".need_close_by_click").removeClass('need_close_by_click').hide()
  true

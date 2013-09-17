@init_more_categories_menu = () ->
  link = $('.filters .by_categories .more_link a')
  block = $('.filters_wrapper .more')

  block.css
    left: link.position().left + link.outerWidth(true, true) - block.outerWidth(true, true)
    top: link.position().top + link.outerHeight()

  link.click ->
    false

  link.mouseenter ->
    block.show()
    true

  link.mouseleave ->
    block.hide()
    true

  block.mouseenter ->
    block.show()
    true

  block.mouseleave ->
    block.hide()
    true

  true

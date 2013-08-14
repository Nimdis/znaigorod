@init_account_extend = () ->
  $('.toggler').click (evt)->
    target = $(evt.target)

    list = target.parent().prev('.list')
    header = list.prev('.header')
    li = $('li', list)

    min_height = li.first().outerHeight(true, true)

    if list.hasClass('votes')
      lines_count = Math.ceil(li.length / 3)
    if list.hasClass('events')
      lines_count = Math.ceil(li.length / 4)
    if list.hasClass('comments')
      lines_count = Math.ceil(li.length)

    max_height = min_height * lines_count

    target.toggleClass('closed opened')
    if target.hasClass('opened')
      list.animate
        height: max_height
      , 500
    if target.hasClass('closed')
      list.animate
        height: min_height
      , 500

      $.scrollTo(header, 500, { offset: {top: -min_height} })

    false

  true

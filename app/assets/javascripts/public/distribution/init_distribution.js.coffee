@init_distribution = () ->
  container = $('.content .distribution')
  dates = $('.dates', container)
  $('li:first', dates).addClass('selected')
  distribution_id = $('li.selected p.date', dates).attr('data-id')
  $(".theaters[data-id=#{distribution_id}]", container).show()

  $('li', dates).click (event) ->
    link = $(this)
    return false if link.hasClass('selected')
    distribution_id = $('li.selected p.date', dates).attr('data-id')
    $(".theaters[data-id=#{distribution_id}]", container).slideUp('fast')
    $('li', dates).removeClass('selected')
    link.addClass('selected')
    distribution_id = $('li.selected p.date', dates).attr('data-id')
    $(".theaters[data-id=#{distribution_id}]", container).slideDown('fast')
    false

  true

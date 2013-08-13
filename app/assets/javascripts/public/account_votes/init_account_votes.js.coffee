@init_account_votes = () ->

  min_height = $('.votes_list li').outerHeight(true, true)

  $('.votes_list').css('height', min_height)

  lines_count = Math.ceil($('.votes_list li').length / 3)
  max_height = min_height * lines_count

  $('.account_votes_toggle').click ->
    $(this).toggleClass('closed').toggleClass('opened')
    if $(this).hasClass('opened')
      $('.votes_list').animate
        height: max_height
      , 500
    if $(this).hasClass('closed')
      $('.votes_list').animate
        height: min_height
      , 500

      $.scrollTo($('.content .votes_header'), 500, { offset: {top: -60} })

    false

  true

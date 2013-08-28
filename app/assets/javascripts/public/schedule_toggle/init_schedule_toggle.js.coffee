@init_schedule_toggle = () ->

  setTimeout ->

    $(".organization_show .show_more_schedule").each (index, item) ->
      link = $(this)
      schedule = link.closest('.work_schedule').next('.more_schedule')
      schedule.css
        top: link.position().top + link.outerHeight(true, true) / 2 - schedule.outerHeight(true, true) / 2
        left: link.position().left + link.outerWidth(true, true) + 10

      link.click () ->
        schedule.removeClass('need_close_by_click').toggle()
        setTimeout ->
          schedule.addClass('need_close_by_click')
        , 1
        true

      true

    true
  , 10

  true

@init_afisha_extend = () ->
  if window.location.hash == '#photogallery' && $.fn.scrollTo
    setTimeout ->
      $.scrollTo($('.afisha_show .photogallery'), 500, { offset: {top: -50} })
      true
    , 300
  if window.location.hash == '#trailer' && $.fn.scrollTo
    setTimeout ->
      $.scrollTo($('.afisha_show .trailer'), 500, { offset: {top: -60} })
      true
    , 300
  true

@init_afisha_tabs = () ->
  $('#events_filter').tabs()

@init_afisha_extend = () ->
  if window.location.hash == '#photogallery' && $.fn.scrollTo
    setTimeout ->
      $.scrollTo($('.content .affiche .photogallery'), 500, { offset: {top: -50} })
    , 300
  if window.location.hash == '#trailer' && $.fn.scrollTo
    setTimeout ->
      $.scrollTo($('.content .affiche .trailer'), 500, { offset: {top: -60} })
    , 300
  true

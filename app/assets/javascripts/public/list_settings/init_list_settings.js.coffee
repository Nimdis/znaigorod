@init_list_settings = () ->
  return false ## THIS SCRIP IS DEPRICATED !
  unless $.cookie
    console.error "$.cookie() is not a function. please include it" if console && console.error
    return false
  $(".content_wrapper .list_settings .sort:not(.saunas) ul li a, .content_wrapper .list_settings .presentation ul li a").each (index, item) ->
    $(item).attr("href", window.location.pathname)
    true
  $.cookie.defaults =
    path: "/"
    expires: 365
  unless $.cookie("znaigorod_affiches_list_settings")
    set_cookie()
  prepare_separators()
  $(".content_wrapper .list_settings .sort ul li a").click (event) ->
    return false if $(this).hasClass("selected")
    $(".content_wrapper .list_settings .sort ul li a").removeClass("selected")
    $(this).addClass("selected")
    prepare_separators()
    set_cookie()
  $(".content_wrapper .list_settings .presentation ul li a").click (event) ->
    return false if $(this).hasClass("selected")
    $(".content_wrapper .list_settings .presentation ul li a").removeClass("selected")
    $(this).addClass("selected")
    set_cookie()
  true

prepare_separators = () ->
  $(".content_wrapper .list_settings ul li .separator").each (index, item) ->
    if $('a', $(this).closest('li').prev()).hasClass('selected') || $('a', $(this).closest('li').next()).hasClass('selected')
      $(this).css
        "border-color": "#845999"
        "background-color": "#845999"
    else
      $(this).css
        "border-color": "#639eba"
        "background-color": "#639eba"
  true

set_cookie = () ->
  list_settings =
    sort: []
    presentation: ""
  sort = $(".content_wrapper .list_settings .sort ul li .selected")
  list_settings.sort.push(sort.attr("class").replace("selected", "").trim())
  presentation = $(".content_wrapper .list_settings .presentation ul li .selected")
  list_settings.presentation = presentation.attr("class").replace("selected", "").trim() if presentation.length
  $.cookie "znaigorod_affiches_list_settings", JSON.stringify(list_settings)
  true

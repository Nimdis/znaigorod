@init_affiche_list_settings = () ->

  unless $.cookie
    console.error '$.cookie() is not a function. please include it' if console && console.error
    return false

  $.cookie.defaults =
    path: '/'
    expires: 365

  view = ''
  order_by = ''

  unless $.cookie('znaigorod_affiches_list_settings')
    window.location.search.replace(/^\?/, '').split('&').map (item) ->
      arr = item.split('=')
      view = arr[1] if arr[0] == 'view'
      order_by = arr[1] if arr[0] == 'order_by'
      true

    if view && order_by
      set_cookie(view, order_by)
    else
      view = $('.content_wrapper .affiches_list .list_settings .presentation a.selected').attr('data')
      order_by = $('.content_wrapper .affiches_list .list_settings .sort a.selected').attr('data')
      set_cookie(view, order_by)
  else
    json = JSON.parse($.cookie('znaigorod_affiches_list_settings'))
    if (json.view != 'list' && json.view != 'posters') || (json.order_by != 'popularity' && json.order_by != 'nearness')
      $.removeCookie('znaigorod_affiches_list_settings')

  $('.content_wrapper .affiches_list .list_settings .sort a').click (event) ->
    return false if $(this).hasClass('selected')
    $('.content_wrapper .affiches_list .list_settings .sort a').removeClass('selected')
    $(this).addClass('selected')
    view = JSON.parse($.cookie('znaigorod_affiches_list_settings')).view
    order_by = $(this).attr('data')
    set_cookie(view, order_by)
  $('.content_wrapper .affiches_list .list_settings .presentation a').click (event) ->
    return false if $(this).hasClass('selected')
    $('.content_wrapper .affiches_list .list_settings .presentation a').removeClass('selected')
    $(this).addClass('selected')
    view = $(this).attr('data')
    order_by = JSON.parse($.cookie('znaigorod_affiches_list_settings')).order_by
    set_cookie(view, order_by)
  true

set_cookie = (view, order_by) ->
  list_settings =
    view: view
    order_by: order_by
  $.cookie 'znaigorod_affiches_list_settings', JSON.stringify(list_settings)
  true

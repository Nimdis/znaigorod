draw_popup = (url, width, height, name) ->
  left = (screen.width/2)-(width/2)
  top = (screen.height/2)-(height/2)
  return window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top)

@init_auth = () ->
  $('.auth_links').on 'click', (evt) ->
    target = $(evt.target)
    if target.is('a')
      draw_popup(target.attr('href'), 600, 400, '...Авторизация...')

    return false

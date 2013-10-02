@init_webcam_swf = () ->

  conteainer = $(".webcam_show .webcam_swf")
  width      = conteainer.attr("data-width")
  height     = conteainer.attr("data-height")
  file       = conteainer.attr("data-file")
  html       = ''

  if FlashDetect && !FlashDetect.installed
    html = '<p>Для воспроизведения видео требуется проигрыватель Adobe Flash.</p><p><a href="http://get.adobe.com/ru/flashplayer/">Загрузить последнюю версию</a></p>'
    conteainer.css
      'color': '#fff'
      'background-color': '#000'
      'display': 'table-cell'
      'height': height
      'vertical-align': 'middle'
      'width': width
      'margin': '0 auto'
    $('a', conteainer).css
      'color': '#bdf'
  else
    html =
      "<object classid='clsid:d27cdb6e-ae6d-11cf-96b8-444553540000' width='#{width}' height='#{height}' codebase='http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0'>" +
      "<param name='allowFullScreen' value='true' />" +
      "<param name='allowScriptAccess' value='always' />" +
      "<param name='bgcolor' value='#ffffff' />" +
      "<param name='data' value='#{file}' />" +
      "<param name='quality' value='high' />" +
      "<param name='salign' value='t' />" +
      "<param name='scale' value='showall' />" +
      "<param name='src' value='#{file}' />" +
      "<param name='wmode' value='opaque' />" +
      "<embed type='application/x-shockwave-flash' width='#{width}' height='#{height}' allowFullScreen'true' allowScriptAccess='always' bgcolor='#ffffff' data='#{file}' quality='high' salign='t' scale='showall' src='#{file}' wmode='opaque' />" +
      "</object>"

  conteainer.html(html)

  true

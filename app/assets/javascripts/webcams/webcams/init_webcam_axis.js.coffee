@init_webcam_axis = () ->

  conteainer = $(".webcam_show .webcam_axis")
  width      = conteainer.attr("data-width")
  height     = conteainer.attr("data-height")
  cgi_url    = conteainer.attr("data-cgi")
  cab_url    = conteainer.attr("data-cab")
  params     = conteainer.attr("data-params") || ''
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
    if navigator.appName == 'Microsoft Internet Explorer' && navigator.platform != 'MacPPC' && navigator.platform != 'Mac68k'
      html =
        "<object id='CamImage' width='#{width}' height='#{height}' classid='CLSID:917623D1-D8E5-11D2-BE8B-00104B06BDE3' codebase='#{cab_url}#Version=1,0,2,15'>" +
        "<param name='DisplaySoundPanel' value=0>" +
        "<param name='url' value='#{cgi_url}?camera=&resolution=#{width}x#{height}&#{new Date().getTime()}#{params}'>" +
        "</object>"
    else
      html =
        "<img src='#{cgi_url}?camera=&resolution=#{width}x#{height}&#{new Date().getTime()}#{params}' " +
        "id='CamImage' " +
        "width='#{width}' height='#{height}' " +
        "alt='Press Reload if no image is displayed'>"

  conteainer.html(html)

  true

@init_webcam_jw = () ->

  conteainer = $(".webcam_show .webcam_jw")
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
    conteainer.html(html)
  else
    html = "" +
      "<div id='jwplayer_container'>" +
      "<video src='#{file} width=#{width} height=#{height} /></video>" +
      "</div>"
    conteainer.html(html)
    jwplayer.key = 'SZeRfk9B2yiaCiIDORB62cYchqlDqQok9qZQCr1qkNg='
    jwplayer('jwplayer_container').setup
      autostart: true
      file: file
      flashplayer: '/assets/jwplayer.swf'
      width: width
      height: height
      fallback: false

  true

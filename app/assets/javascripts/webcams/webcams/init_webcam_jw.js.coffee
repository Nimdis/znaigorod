@init_webcam_jw = () ->

  init_webcam_dialog = () ->
    unless $("#webcam_dialog").length
      $("<div id='webcam_dialog' />").appendTo("body")
    $("#webcam_dialog")

  render_jwobject_dialog = (width, height, file, dialog_title) ->
    webcam_dialog = init_webcam_dialog()
    webcam_dialog.html("").hide()
    if FlashDetect && FlashDetect.installed
      html = "" +
        "<center>" +
        "<div id='jwplayer_container'>" +
        "<video src='#{file} width=#{width} height=#{height} /></video>" +
        "</div>" +
        "</center>"
      $(html).appendTo(webcam_dialog)
    else
      html = "" +
        "<center>" +
        "<div id='jwplayer_container'>" +
        "</div>" +
        "</center>"
      $(html).appendTo(webcam_dialog)
      $('#jwplayer_container').html('<p>Для воспроизведения видео требуется проигрыватель Adobe Flash.</p><p><a href="http://get.adobe.com/ru/flashplayer/">Загрузить последнюю версию</a></p>')
      $('#jwplayer_container').css
        'color': '#fff'
        'background-color': '#000'
        'display': 'table-cell'
        'height': height
        'vertical-align': 'middle'
        'width': width
        'margin': '0 auto'
      $('#jwplayer_container a').css
        'color': '#bdf'
    webcam_dialog.dialog
      title: dialog_title
      modal: true
      width: width.toNumber() + 36
      height: height.toNumber() + 46
      resizable: false
      open: (event, ui) ->
        jwplayer.key = 'SZeRfk9B2yiaCiIDORB62cYchqlDqQok9qZQCr1qkNg='
        jwplayer('jwplayer_container').setup
          autostart: true
          file: file
          flashplayer: '/assets/jwplayer.swf'
          width: width
          height: height
          fallback: false
        true
      close: (event, ui) ->
        $(this).dialog('destroy')
        $(this).remove()
        true
    true

  $(".webcams_list .webcam_jw").each (index, item) ->
    block = $(this)
    link = $("a", block)
    link.click (event) ->
      width = block.attr("data-width")
      height = block.attr("data-height")
      file = block.attr("data-file")
      dialog_title = "#{link.text()}. #{link.next("p").text()}"
      render_jwobject_dialog(width, height, file, dialog_title)
      false
    true
  true

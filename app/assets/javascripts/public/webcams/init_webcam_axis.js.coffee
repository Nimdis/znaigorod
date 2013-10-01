@init_webcam_axis = () ->

  init_webcam_dialog = () ->
    unless $("#webcam_dialog").length
      $("<div id='webcam_dialog' />").appendTo("body")
    $("#webcam_dialog")

  render_axis_object = (width, height, cgi_url, cab_url, params) ->
    "<center>" +
    "<object id='CamImage' width='#{width}' height='#{height}' classid='CLSID:917623D1-D8E5-11D2-BE8B-00104B06BDE3' codebase='#{cab_url}#Version=1,0,2,15'>" +
    "<param name='DisplaySoundPanel' value=0>" +
    "<param name='url' value='#{cgi_url}?camera=&resolution=#{width}x#{height}&#{new Date().getTime()}#{params}'>" +
    "</object>" +
    "</center>"

  render_axis_image = (width, height, cgi_url, params) ->
    "<center>" +
    "<img src='#{cgi_url}?camera=&resolution=#{width}x#{height}&#{new Date().getTime()}#{params}' " +
    "id='CamImage' " +
    "width='#{width}' height='#{height}' " +
    "alt='Press Reload if no image is displayed'>" +
    "</center>"

  render_axis_dialog = (width, height, cgi_url, cab_url, params, dialog_title) ->
    webcam_dialog = init_webcam_dialog()
    webcam_dialog.html("").hide()
    params = "&#{params}" if params.length
    if FlashDetect && !FlashDetect.installed
      $("<center><div id='swfobject_container' /></center>").appendTo(webcam_dialog)
      $('#swfobject_container').html('<p>Для воспроизведения видео требуется проигрыватель Adobe Flash.</p><p><a href="http://get.adobe.com/ru/flashplayer/">Загрузить последнюю версию</a></p>')
      $('#swfobject_container').css
        'color': '#fff'
        'background-color': '#000'
        'display': 'table-cell'
        'height': height
        'vertical-align': 'middle'
        'width': width
        'margin': '0 auto'
      $('#swfobject_container a').css
        'color': '#bdf'
    else
      if navigator.appName == 'Microsoft Internet Explorer' && navigator.platform != 'MacPPC' && navigator.platform != 'Mac68k'
        webcam_dialog.html(render_axis_object(width, height, cgi_url, cab_url, params))
      else
        webcam_dialog.html(render_axis_image(width, height, cgi_url, params))


    webcam_dialog.dialog
      title: dialog_title
      modal: true
      width: width.toNumber() + 36
      height: height.toNumber() + 49
      resizable: false
      open: (event, ui) ->
        true
      close: (event, ui) ->
        $(this).dialog('destroy')
        $(this).remove()
        window.stop() unless navigator.appName == "Microsoft Internet Explorer"
        true

    true

  $(".webcams_list .webcam_axis").each (index, item) ->
    block = $(this)
    link = $("a", block)
    link.click (event) ->
      width = block.attr("data-width")
      height = block.attr("data-height")
      cgi_url = block.attr("data-cgi")
      cab_url = block.attr("data-cab")
      params = block.attr("data-params") || ''
      dialog_title = "#{link.text()}. #{link.next("p").text()}"
      render_axis_dialog(width, height, cgi_url, cab_url, params, dialog_title)
      false
    true

  true

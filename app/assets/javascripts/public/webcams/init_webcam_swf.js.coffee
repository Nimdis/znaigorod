@init_webcam_swf = () ->

  init_webcam_dialog = () ->
    unless $("#webcam_dialog").length
      $("<div id='webcam_dialog' />").appendTo("body")
    $("#webcam_dialog")

  render_swfobject_dialog = (width, height, file, dialog_title) ->
    webcam_dialog = init_webcam_dialog()
    webcam_dialog.html("").hide()
    html = "<center>" +
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
      "</object>" +
      "</center>"
    $(html).appendTo(webcam_dialog)
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
        true
    true

  $(".webcams_list .webcam_swf").each (index, item) ->
    block = $(this)
    link = $("a", block)
    link.click (event) ->
      width = block.attr("data-width")
      height = block.attr("data-height")
      file_hash = block.attr("data-file")
      dialog_title = "#{link.text()}. #{link.next("p").text()}"
      render_swfobject_dialog(width, height, file_hash, dialog_title)
      false
    true
  true

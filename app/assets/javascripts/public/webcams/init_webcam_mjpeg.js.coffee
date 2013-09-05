@init_webcam_mjpeg = () ->

  init_webcam_dialog = () ->
    unless $("#webcam_dialog").length
      $("<div id='webcam_dialog' />").appendTo("body")
    $("#webcam_dialog")

  render_mjpeg_dialog = (width, height, file, dialog_title) ->
    webcam_dialog = init_webcam_dialog()
    webcam_dialog.html("").hide()
    html = "<center>" +
      "<img src='#{file}?rate=0&user=user&pwd=pwd' width='#{width}' height='#{height}' />" +
      "</center>"
    $(webcam_dialog).html(html)
    webcam_dialog.dialog
      title: dialog_title
      modal: true
      width: width.toNumber() + 36
      height: height.toNumber() + 46
      resizable: false
      close: (event, ui) ->
        $(this).dialog('destroy')
        $(this).remove()
        window.stop()
        true
    true

  $(".webcams_list .webcam_mjpeg").each (index, item) ->
    block = $(this)
    link = $("a", block)
    link.click (event) ->
      width = block.attr("data-width")
      height = block.attr("data-height")
      file_hash = block.attr("data-file")
      dialog_title = "#{link.text()}. #{link.next("p").text()}"
      render_mjpeg_dialog(width, height, file_hash, dialog_title)
      false
    true
  true

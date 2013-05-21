@init_webcam_axis = () ->
  $(".webcams_list .webcam_axis").each (index, item) ->
    block = $(this)
    link = $("a", block)
    link.click (event) ->
      width = block.attr("data-width")
      height = block.attr("data-height")
      cab_url = block.attr("data-cab")
      cgi_url = block.attr("data-cgi")
      dialog_title = "#{link.text()}. #{link.next("p").text()}"
      render_axis_dialog(width, height, cab_url, cgi_url, dialog_title)
      false
    true
  true

init_webcam_dialog = () ->
  unless $("#webcam_dialog").length
    $("<div id='webcam_dialog' />").appendTo("body")
  $("#webcam_dialog")

render_axis_dialog = (width, height, cab_url, cgi_url, dialog_title) ->
  webcam_dialog = init_webcam_dialog()
  webcam_dialog.html("").hide()
  if navigator.appName == "Microsoft Internet Explorer" && navigator.platform != "MacPPC" && navigator.platform != "Mac68k"
    webcam_dialog.html(render_axis_object(width, height, cab_url, cgi_url))
  else
    webcam_dialog.html(render_axis_image(width, height, cgi_url))
  webcam_dialog.dialog
    title: dialog_title
    modal: true
    width: width.toNumber() + 36
    height: height.toNumber() + 44
    resizable: false
    close: ->
      $(this).parent().remove()
      $(this).remove()
      true
  true

render_axis_object = (width, height, cab_url, cgi_url) ->
  "<center>" +
  "<object width='#{width}' height='#{height}' codebase='#{cab_url}#Version=1,0,2,15'>" +
  "<param name='DisplaySoundPanel' value=0>" +
  "<param name='url' value='#{cgi_url}?camera=&resolution=#{width}x#{height}'>" +
  "</object>" +
  "</center>"

render_axis_image = (width, height, cgi_url) ->
  "<center>" +
  "<img src='#{cgi_url}?camera=&resolution=#{width}x#{height}&#{new Date().getTime()}' " +
  " width='#{width}' height='#{height}' " +
  "alt='Press Reload if no image is displayed'>" +
  "</center>"

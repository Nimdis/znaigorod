@init_webcam_uppod = () ->
  $(".webcams_list .webcam_uppod").each (index, item) ->
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

init_webcam_dialog = () ->
  unless $("#webcam_dialog").length
    $("<div id='webcam_dialog' />").appendTo("body")
  $("#webcam_dialog")

render_swfobject_dialog = (width, height, file_hash, dialog_title) ->
  webcam_dialog = init_webcam_dialog()
  webcam_dialog.html("").hide()
  $("<center><div id='swfobject_container' /></center>").appendTo(webcam_dialog)
  conf = swf_config(width, height, file_hash)
  swfobject.embedSWF(
    conf.swfUrl,
    conf.id,
    conf.width,
    conf.height,
    conf.version,
    conf.expressInstallSwfurl,
    conf.flashvars,
    conf.params,
    conf.attributes
  )
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

swf_config = (width, height, file_hash) ->
  "swfUrl": "/assets/player.swf"
  "id": "swfobject_container"
  "width": width.toNumber()
  "height": height.toNumber()
  "version": "9.0.115"
  "expressInstallSwfurl": "/assets/exp_inst.swf"
  "flashvars":
    "file": file_hash
    "vast_preroll": "/assets/vastconverter.xml"
    "vast_overlay": "/assets/vastconverter.xml"
    "st": "/assets/webcam.txt"
  "params":
    "bgcolor": "#ffffff"
    "allowFullScreen": "true"
    "allowScriptAccess": "always"
    "wmode": "opaque"
  "attributes":
    "id":"swfobject_container"
    "name":"swfobject_container"

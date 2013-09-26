@init_webcam_uppod = () ->

  init_webcam_dialog = () ->
    unless $("#webcam_dialog").length
      $("<div id='webcam_dialog' />").appendTo("body")
    $("#webcam_dialog")

  render_swfobject_dialog = (width, height, file_hash, dialog_title) ->
    webcam_dialog = init_webcam_dialog()
    webcam_dialog.html("").hide()
    $("<center><div id='swfobject_container' /></center>").appendTo(webcam_dialog)
    if FlashDetect && FlashDetect.installed
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
    else
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
    webcam_dialog.dialog
      title: dialog_title
      modal: true
      width: width.toNumber() + 36
      height: height.toNumber() + 49
      resizable: false
      create: (event, ui) ->
        $('body').css
          overflow: 'hidden'
        true
      beforeClose: (event, ui) ->
        $("body").css
          overflow: 'inherit'
        true
      close: (event, ui) ->
        $(this).dialog('destroy')
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

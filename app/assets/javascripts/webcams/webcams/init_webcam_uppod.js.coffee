@init_webcam_uppod = () ->

  conteainer = $(".webcam_show .webcam_uppod")
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
    conteainer.html("<div id='swfobject_container' />")
    swf_config =
      "swfUrl": "/assets/player.swf"
      "id": "swfobject_container"
      "width": width.toNumber()
      "height": height.toNumber()
      "version": "9.0.115"
      "expressInstallSwfurl": "/assets/exp_inst.swf"
      "flashvars":
        "file": file
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

    swfobject.embedSWF(
      swf_config.swfUrl,
      swf_config.id,
      swf_config.width,
      swf_config.height,
      swf_config.version,
      swf_config.expressInstallSwfurl,
      swf_config.flashvars,
      swf_config.params,
      swf_config.attributes
    )

  true

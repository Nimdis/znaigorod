@init_galleria = () ->
  $(".content .gallery_container li").each (index, item) ->
    if $(this).width() < $("img", this).attr("width")
      $(this).css
        position: "relative"
      $("img", this).css
        position: "absolute"
        left: - ($("img", this).attr("width") - $(this).width()) / 2
    $("a", this).attr("rel", "colorbox")
    true
  $(".content .gallery_container li a").colorbox
    "close": "закрыть"
    "current": "{current} / {total}"
    "maxHeight": "98%"
    "maxWidth": "90%"
    "next": "следующая"
    "opacity": "0.6"
    "photo": "true"
    "previous": "предыдущая"
  true

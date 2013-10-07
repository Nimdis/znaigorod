@init_webcam_map = () ->

  ymaps.ready ->
    $map = $('.webcams .webcam_map')

    map = new ymaps.Map $map[0],
      center: [$map.attr('data-latitude'), $map.attr('data-longitude')]
      zoom: 12
      behaviors: ['drag', 'scrollZoom']
    ,
      maxZoom: 23
      minZoom: 12

    map.controls.add 'zoomControl',
      top: 5
      left: 5

    $('.webcams .webcams_list p').each (index, item) ->
      link = $('a', item)
      id = link.attr('id')
      title = link.text()

      link.popupWindow
        windowURL: link.attr('href')
        centerBrowser: 1
        width: $(item).attr('data-width').toNumber() + 350
        height: $(item).attr('data-height').toNumber() + 130
        location: 1

      point = new ymaps.GeoObject
        geometry:
          type: 'Point'
          coordinates: [$(item).attr('data-latitude'), $(item).attr('data-longitude')]
        properties:
          balloonContentHeader: "" +
            "<center style='margin-bottom:5px;font-size:12px;'>" +
            "<a href='#{link.attr('href')}' class='balloon_link' data-id='balloon_link_id_#{id}'>" +
            $(item).attr('data-title') +
            "</a>" +
            "</center>"
          balloonContentBody: "" +
            "<center>" +
            "<a href='#{link.attr('href')}' class='balloon_link' data-id='balloon_link_id_#{id}'>" +
            "<img width='200' height='150' src='#{$(item).attr('data-image')}' />" +
            "</a>" +
            "<br />" +
            "<a href='#{link.attr('href')}' class='balloon_link' data-id='balloon_link_id_#{id}'>" +
            $(item).attr('data-address') +
            "</a>" +
            "</center>"
          hintContent: title
          id: id
      ,
        iconImageHref: '/assets/public/icon_map_webcam.png'
        iconImageOffset: [-15, -40]
        iconImageSize: [37, 42]

      point.events.add 'mouseenter', (event) ->
        point.balloon.open()
        true

      point.balloon.events.add 'open', (event) ->
        $('a.balloon_link').unbind('click').click ->
          link = $("##{$(this).attr('data-id').replace('balloon_link_id_', '')}")
          if navigator.appName == 'Microsoft Internet Explorer' && navigator.platform != 'MacPPC' && navigator.platform != 'Mac68k'
            $.cookie('_show_webcam_in_ie', 'true')
          link.click()
          false
        true

      map.geoObjects.add point

      true

    true

  true

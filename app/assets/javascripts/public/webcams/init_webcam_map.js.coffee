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
          id: id
          hintContent: title
      ,
        iconImageHref: '/assets/public/icon_map_webcam.png'
        iconImageOffset: [-15, -40]
        iconImageSize: [37, 42]

      point.events.add 'click', (event) ->
        link = $("##{event.get('target').properties.get('id')}")
        if navigator.appName == 'Microsoft Internet Explorer' && navigator.platform != 'MacPPC' && navigator.platform != 'Mac68k'
          $.cookie('_show_webcam_in_ie', 'true')
        link.click()

        true

      map.geoObjects.add point

      true

    true

  true

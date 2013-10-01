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
      link = $(item).prev('a')
      title = "#{link.text().compact().normalize()}. #{$(item).text().compact().normalize()}"
      id = URLify(link.text().compact().normalize())

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
        hash = event.get('target').properties.get('id')
        link.click()

      map.geoObjects.add point

      true

    true

  true

@add_point_on_side_map = (item, map) ->

  point = new ymaps.GeoObject
    geometry:
      type: 'Point'
      coordinates: [$(item).attr('data-latitude'), $(item).attr('data-longitude')]
    properties:
      hintContent: $(item).attr('data-hint')
      balloonContent: "#{$(item).attr('data-hint')} "
      openBalloonOnClick: true
  ,
      preset: 'twirl#blueIcon'

  point.events.add 'click', (event) ->
    content = event.get('target').properties.get('balloonContent')
    coordinates = event.get('target').geometry.getCoordinates()
    $.ajax
      url: '/yamp_geocoder_photo?coords=' + coordinates[1] + ', ' + coordinates[0]
      success: (response, textStatus, jqXHR) ->
        if response.length > 0
          if $(content).length == 0
            content = "<img src='#{response[0].XXXS.href}' />" + "<br />" + content
        else
          content = content # somebody should add here an unfound image
        event.get('target').properties.singleSet('balloonContent', content)
        true

  map.geoObjects.add point if (typeof map != 'undefined')

  true

@init_addresses_side_map = () ->

  ymaps.ready ->
    $map = $('.results_with_map .yandex_side_map')

    map = new ymaps.Map $map[0],
      center: [56.482697, 84.94967] #should give coordinates for this block
      zoom: 12
      behaviors: ['drag', 'scrollZoom']
    ,
      maxZoom: 23
      minZoom: 12

    map.controls.add 'zoomControl',
      top: 5
      left: 5

    $('.results_with_map .result_list .show_map_link').each (index, item) ->

      add_point_on_side_map(item, map)

      true

    init_addresses_pagination(map)

    true

  true

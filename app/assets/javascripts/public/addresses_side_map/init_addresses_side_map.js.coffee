@init_addresses_pagination = (map) ->
  busy = false
  list = $('.result_list')
  pagination = $('.pagination')
  next_link = $('.next a', pagination)

  list.jScrollPane
    autoReinitialise: true
    verticalGutter: 0
    showArrows: true
    mouseWheelSpeed: 30

  block_offset = $('li:last', list).outerHeight(true, true) * ($('li', list).length - 3) - $('.jspContainer', list).outerHeight(true, true)
  if next_link.length
    list.bind 'jsp-scroll-y', (event, scrollPositionY, isAtTop, isAtBottom) ->
      if block_offset < scrollPositionY && !busy
        busy = true
        $.ajax
          url: next_link.attr('href')
          success: (response, textStatus, jqXHR) ->
            return true if (typeof next_link.attr('href')) == 'undefined'
            list = $("#{response}").find('.result_list').children()
            $('.jspPane', event.target).append(list)
            block_offset = $('li:last', event.target).outerHeight(true, true) * ($('li', event.target).length - 30) - $('.jspContainer', list).outerHeight(true, true)
            busy = false
            pagination.html($('.pagination', response).html())
            next_link = $('.next a', pagination)
            $("#{response}").find('.result_list .show_map_link_side_map').each (index, item) ->
              add_point_on_side_map(item, map)
              true
            true
        true
    true

@add_point_on_side_map = (item, map) ->

  set_photos_to_balloon = (point) ->
    content = point.properties.get('balloonContent')
    coordinates = point.geometry.getCoordinates()
    $.ajax
      url: '/yamp_geocoder_photo?coords=' + coordinates[1] + ', ' + coordinates[0]
      success: (response, textStatus, jqXHR) ->
        if response.length > 0
          if $(content).length == 0
            content = "<center><img src='#{response[0].S.href}' /></center>" + content
        else
          content = content # somebody should add here an unfound image
        point.properties.singleSet('balloonContent', content)
        true


  add_events_to_list = (point) ->

    data_hint = point.properties.get('hintContent')
    elem = $(".yandex_addresses_side_map [data-hint='#{data_hint}']").parent().parent()

    elem.mouseenter () ->
      if !elem.hasClass("clicked")
        elem.css({'background': '#f5f3f3'})
        point.options.set('preset', 'twirl#redIcon')
        if (map.getZoom() < 17)
          map.geoObjects.remove(point)
          map.geoObjects.add(point)

    elem.mouseleave () ->
      if !elem.hasClass("clicked")
        elem.css({'background': '#fff'})
        point.options.set('preset', 'twirl#blueIcon')

    elem.click () ->
      if elem.hasClass("clicked")
        elem.removeClass("clicked")
        elem.css({'background': '#fff'})
        point.balloon.close()
      else
        map.setCenter(point.geometry.getCoordinates())
        map.setZoom(17) if map.getZoom() != 17
        elem.css({'background': '#e3e3e3'})
        $('.result_list .clicked').removeClass("clicked")
        elem.addClass("clicked")
        set_photos_to_balloon(point)
        point.balloon.open()
      false

  add_events_on_map = (point) ->

    data_hint = point.properties.get('hintContent')
    elem = $(".yandex_addresses_side_map [data-hint='#{data_hint}']").parent().parent()

    point.events.add 'mouseenter', (event) ->
      point.options.set('preset', 'twirl#redIcon')
      elem.css({'background': '#f5f3f3'})

    point.events.add 'mouseleave', (event) ->
      point.options.set('preset', 'twirl#blueIcon')
      elem.css({'background': '#fff'})

    point.balloon.events.add 'close', (event) ->
      point.options.set('preset', 'twirl#blueIcon')
      elem.css({'background': '#fff'})
      elem.removeClass("clicked")

    point.events.add 'click', (event) ->
      elem.css({'background': '#e3e3e3'})
      $('.result_list .clicked').removeClass("clicked")
      elem.addClass("clicked")
      set_photos_to_balloon(event.get('target'))

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

  add_events_on_map(point)

  add_events_to_list(point)

  map.geoObjects.add point if (typeof map != 'undefined')

  true

@init_addresses_side_map = () ->

  ymaps.ready ->
    $map = $('.results_with_map .yandex_side_map')

    map = new ymaps.Map $map[0],
      center: [56.482697, 84.94967] 
      zoom: 12
      behaviors: ['drag', 'scrollZoom']
    ,
      maxZoom: 23
      minZoom: 12

    map.controls.add 'zoomControl',
      top: 5
      left: 5

    $('.results_with_map .result_list .show_map_link_side_map').each (index, item) ->

      add_point_on_side_map(item, map)

      true

    init_addresses_pagination(map)

    true

  true

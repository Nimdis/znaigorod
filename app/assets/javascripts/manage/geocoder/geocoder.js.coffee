@init_organization_map = () ->
  form = $('.edit_organization, .new_organization')
  $map = $('#map')
  map = $map.draw_organization_map()
  street_field = $('#organization_address_attributes_street')
  house_field = $('#organization_address_attributes_house')
  latitude_field = $('#organization_address_attributes_latitude')
  longitude_field = $('#organization_address_attributes_longitude')
  $('.get_coordinates', form).click ->
    return false if street_field.val() == '' || house_field.val() == ''
    $.ajax
      url: "/yamp_geocoder"
      async: false
      dataType: "json"
      data: "street=#{street_field.val()}&house=#{house_field.val()}"
      success:  (json, textStatus, jqXHR) ->
        if json.response_code == '500'
          alert "Cервис временно не доступен"
          return false
        latitude_field.val(json.latitude)
        longitude_field.val(json.longitude)
        map.setCenter [json.latitude, json.longitude]
        map.geoObjects.each (geoObject) ->
          if (geoObject.properties.get('id') == 'placemark')
            geoObject.geometry.setCoordinates [json.latitude, json.longitude]
          true
        if json.response_code == '404'
          alert "Координаты по указанному адресу не найдены!\nПожалуйста уточните адрес\nИли сохраняйте без указания координат"
        true
    false
  true

$.fn.draw_organization_map = () ->
  $map = $(this)
  street_field = $('#organization_address_attributes_street')
  house_field = $('#organization_address_attributes_house')
  latitude_field = $('#organization_address_attributes_latitude')
  longitude_field = $('#organization_address_attributes_longitude')
  latitude = latitude_field.val() || '56.488611121111'
  longitude = longitude_field.val() || '84.952222232222'

  map = new ymaps.Map $map[0],
    center: [latitude, longitude]
    zoom: 16
    behaviors: ['drag', 'scrollZoom']
  ,
    maxZoom: 23
    minZoom: 12

  map.controls.add 'zoomControl',
    top: 5
    left: 5

  placemark = new ymaps.GeoObject
    geometry:
      type: 'Point'
      coordinates: [latitude, longitude]
    properties:
      id: 'placemark'
  ,
    draggable: true
    iconImageHref: '/assets/public/affiche_placemark.png'
    iconImageOffset: [-15, -40]
    iconImageSize: [37, 42]

  map.geoObjects.add(placemark)

  placemark.events.add 'dragend', (event) ->
    coordinates = placemark.geometry.getCoordinates()
    latitude_field.val (coordinates[0] + '').substring(0, 9)
    longitude_field.val (coordinates[1] + '').substring(0, 9)
    true

  map.events.add 'click', (event) ->
    coordinates = event.get('coordPosition')
    latitude_field.val (coordinates[0] + '').substring(0, 9)
    longitude_field.val (coordinates[1] + '').substring(0, 9)
    map.geoObjects.each (geoObject) ->
      if (geoObject.properties.get('id') == 'placemark')
        geoObject.geometry.setCoordinates [coordinates[0], coordinates[1]]
      true
    true

  map

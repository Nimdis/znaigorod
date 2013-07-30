@init_choose_coordinate = () ->
  link = $('.choose_coordinate')
  link.each ->
    $(this).add_click_handler()
    true
  $('form').on 'nested:fieldAdded', (event) ->
    $('.choose_coordinate', event.field).add_click_handler()
    true

  true

$.fn.add_click_handler = () ->
  $this = $(this)
  $this.prepare_affiche_coordenates()
  $this.click ->
    if $('.map_wrapper').length
      container = $('.map_wrapper')
    else
      container = $('<div class="map_wrapper" style="width:640px; height: 480px;" />').appendTo('body').hide()
    latitude = $('.latitude', $(this).parent())
    longitude = $('.longitude', $(this).parent())
    coordinates = { 'latitude': latitude.val(), 'longitude': longitude.val() }
    map = null

    container.dialog
      draggable: false
      height: 480
      modal: true
      resizable: false
      title: 'Укажите координаты места проведения'
      width: 640
      zIndex: 700
      open: ->
        map = container.draw_affiche_map($this, coordinates)
      close: ->
        map.destroy()
    false

  true

$.fn.draw_affiche_map = (link, coordinates) ->
  $map = $(this)
  latitude = coordinates.latitude || '56.488611121111'
  longitude = coordinates.longitude || '84.952222232222'

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

  map.events.add 'click', (event) ->
    coordinates = event.get('coordPosition')
    $('.latitude', $(link).parent()).val coordinates[0]
    $('.longitude', $(link).parent()).val coordinates[1]
    $(link).addClass('with_coordinates')
    map.geoObjects.each (geoObject) ->
      if (geoObject.properties.get('id') == 'placemark')
        geoObject.geometry.setCoordinates [coordinates[0], coordinates[1]]
      true
    true

  placemark.events.add 'dragend', (event) ->
    coordinates = placemark.geometry.getCoordinates()
    $('.latitude', $(link).parent()).val coordinates[0]
    $('.longitude', $(link).parent()).val coordinates[1]
    $(link).addClass('with_coordinates')
    true

  map

$.fn.prepare_affiche_coordenates = () ->
  return true if $('.latitude', $(this).parent()).val().length && $('.longitude', $(this).parent()).val().length
  prev_fields = $(this).parent().prev('.fields:visible')
  if prev_fields.length && $('.latitude', prev_fields).val().length && $('.longitude', prev_fields).val().length
    $('.latitude', $(this).parent()).val $('.latitude', prev_fields).val()
    $('.longitude', $(this).parent()).val $('.longitude', prev_fields).val()
    $(this).addClass('with_coordinates')

  true

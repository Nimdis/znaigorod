get_coordinates = () ->
  coords = {}
  coords['lat'] = 56.484605
  coords['lon'] = 84.948128
  coords['radius'] = 11
  coords['title']  = 'Ваше местоположение'
  if $('#geo').hasClass('used')
    $('.filter_geo:visible .hidden_inputs input').each (index, item) ->
      $item = $(item)
      switch $item.attr('class')
        when 'lat'    then coords['lat'] = $item.val()
        when 'lon'    then coords['lon'] = $item.val()
        when 'radius' then coords['radius'] = $item.val()
  coords

set_coordinates = (coords) ->
  $('.filter_geo:visible .hidden_inputs input').each (index, item) ->
    $item = $(item)
    switch $item.attr('class')
      when 'lat'    then $item.val(coords['lat'])
      when 'lon'    then $item.val(coords['lon'])
      when 'radius' then $item.val(coords['radius'])

initialize_map = () ->
  draw_map(get_coordinates())

draw_map = (coords) ->
  container = $('.filter_geo .map_wrapper')[0]
  center    = new DG.GeoPoint(coords.lon, coords.lat)
  map       = new DG.Map(container)
  scale     = 14 #TODO: JS#Менять масштаб в зависимости от радиуса
  DG.autoload ->
  map.controls.add(new DG.Controls.Zoom())
  map.setCenter(center, scale)
  map.geoclicker.disable()
  map.fullscreen.disable()
  self_marker = create_marker(coords, 'self')
  map.markers.add(self_marker)

  $(map).draw_circle(coords)
  radius_slider_handler(coords)
  set_coordinates(coords)

  if !$('#geo').hasClass('used')
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(
        (position) ->
          coords['lat'] = position.coords.latitude
          coords['lon'] = position.coords.longitude
          set_coordinates(coords)
          self_marker.setPosition(new DG.GeoPoint(coords.lon, coords.lat))
          map.setCenter(new DG.GeoPoint(coords.lon, coords.lat), scale)
          $(map).draw_circle(coords)
      )

  get_items_locations().each (item, index) ->
    return true if item.lat == undefined
    item_marker = create_marker(item, 'item')
    map.markers.add(item_marker)

  $('.filter_geo input.radius').on 'change', ->
    if $(this).val() == ''
      coords.radius = 11
      $('.info_radius .rad').html(parseFloat(coords.radius)*1000)
      $('.info_radius .time').html(((parseFloat(coords.radius)*1000)/54.6).toFixed(1))
      $(map).draw_circle(coords)
    else
      coords.radius = $(this).val()
      $('.info_radius .rad').html(parseFloat(coords.radius)*1000)
      $('.info_radius .time').html(((parseFloat(coords.radius)*1000)/54.6).toFixed(1))
      $(map).draw_circle(coords)

  self_marker_listener = map.addEventListener(
    map,
    'DgClick',
    (event) ->
      coordinate = event.getGeoPoint()
      coords.lat = coordinate.lat
      coords.lon = coordinate.lon
      self_marker.setPosition(new DG.GeoPoint(coords.lon, coords.lat))
      $(map).draw_circle(coords)
      set_coordinates(coords)
  )
  $('#geo .remove_filter_link:visible').on 'click', ->
    $(map).removeClass('olMap').off()
    $('.filter_geo input.radius').off()
    self_marker_listener.disable() if self_marker_listener
    self_marker_listener.cleanup() if self_marker_listener
    map.destroy() if map
    $('.map_wrapper').removeClass('olMap')
    self_marker_listener = null
    map = null
  map

$.fn.draw_circle = (coords) ->
  map = this[0]
  map.geometries.removeAll()
  style = new DG.Style.Geometry()
  style.strokeColor = "#71706e"
  style.strokeOpacity = 0.6
  style.strokeWidth = 1
  style.fillColor = "#fdfffe"
  style.fillOpacity = 0.5
  circle = new DG.Geometries.Circle(new DG.GeoPoint(coords.lon, coords.lat), coords.radius*1000, style)
  map.geometries.add(circle)

create_marker = (coords, type) ->
  if type == 'self'
    icon = new DG.Icon()
    icon = new DG.Icon(
      '/assets/self_marker.png',
      new DG.Size(17, 31)
    )
  else
    icon = new DG.Icon(
      '/assets/item_marker.png',
      new DG.Size(16, 20)
    )

  new DG.Markers.MarkerWithBalloon {
    geoPoint: new DG.GeoPoint(coords.lon, coords.lat),
    icon: icon
    balloonOptions:
      headerContentHtml: coords['title']
      contentHtml: coords['address']
      isClosed: false
  }

radius_slider_handler = (coords) ->
  $('.radius_slider').slider
    max:  11
    min:  0.1
    step: 0.05
    value: parseFloat(coords.radius)
    create: () ->
     $(this).parent().find('.ui-corner-all').removeClass('ui-corner-all')

    slide: (event, ui) ->
      $('.filter_geo input.radius').val(ui.value).change()

    stop: (event, ui) ->
      $('.filter_geo input.radius').val(ui.value).change()

get_items_locations = () ->
  items_coords = []
  $('.organization_attributes .attributes').each (index, item) ->
    $item = $(item)
    item_coords = {}
    item_coords['title'] = $item.children('a')[0].outerHTML
    item_coords['address'] = $item.children('.address').find('a').text()
    item_coords['lat']   = $item.children('.address').find('a').attr('latitude')
    item_coords['lon']   = $item.children('.address').find('a').attr('longitude')
    items_coords.push(item_coords)

  return items_coords

criteria_handler = () ->
  $('.criteria_list ul li a').on 'click', ->
    target = $('#'+$(this).attr('class'))
    $(this).add(target).toggle()
    target.find('input').removeAttr('disabled')
    initialize_map() if $(this).hasClass('geo')
    false

set_previous_state = () ->
  $('.filters_wrapper .hide').each (index, item) ->
    $(item).hide().find('input').attr('disabled', 'disabled')

  $('.filters_wrapper .show').each (index, item) ->
    $('.'+$(item).attr('id'), '.filters_wrapper').hide()

remove_filter_handler = () ->
  $('.remove_filter_link').on 'click', ->
    filter = $(this).parent()
    filter.find('input').val('').attr('checked', false).attr('disabled','disabled').change()
    filter.find('.ms-sel-ctn').html('')
    $('.'+filter.removeClass('used').toggle().attr('id'), '.filters_wrapper').toggle()
    false

clear_filter_handler = () ->
  $('.clear_filter_link').on 'click', ->
    filter = $(this).parent()
    filter.find('input').val('').attr('checked', false).change()
    filter.find('.ms-sel-ctn').html('')
    false

clear_form_handler = () ->
  $('.clear_wrapper a').on 'click', ->
    $('.filters_wrapper .filter_inputs input').val('').change()
    $('.filters_wrapper .filter_checkboxes input').attr('checked', false).change()
    $('.filters_wrapper .remove_filter_link:visible').click()
    false

$.fn.draw_scale = (min, max) ->
  middle = (max / 2.0).round()
  scale_block = $(this).before('<div class="scale_block">
                                <span class="min">'+min+'</span>
                                <span class="middle">'+middle+'</span>
                                <span class="max">'+max+'</span>
                              </div>')

filter_slider_handler = () ->
  $('.filter_slider').each (index, item) ->
    $(item).add_handler()

$.fn.add_handler = () ->
  filter_slider = $(this)
  min = filter_slider.data('min')
  max = filter_slider.data('max')
  range = filter_slider.data('range')
  step = filter_slider.data('step')
  if range == true
    values = [min, max]
  else if range == false
    values = 0
  else if range.match(/min/)
    values = max
  else if range.match(/max/)
    values = min

  filter_slider.draw_scale(min, max)

  filter_slider.parent().siblings('.filter_inputs').find('input').on 'change', ->
    value = $(this).val()
    if $(this).hasClass('min')
      if value.match(/\d+/)
        filter_slider.slider('values', 0, value)
      else
        filter_slider.slider('values', 0, min)
    if $(this).hasClass('max')
      if value.match(/\d+/)
        filter_slider.slider('values', 1, value)
      else
        filter_slider.slider('values', 1, max)

  filter_slider.slider
    max: max
    min: min
    range: range
    step: step
    values: values
    create: (event, ui) ->
      filter_slider.parent().find('.ui-corner-all').removeClass('ui-corner-all')
      if range == true
        filter_slider.find('.ui-slider-handle').map (index, item) ->
          $(item).addClass('handle'+index)
      else if range == false
        filter_slider.find('.ui-slider-handle').addClass('handle1')
      else if range.match(/min/)
        filter_slider.find('.ui-slider-handle').addClass('handle1')
      else if range.match(/max/)
        filter_slider.find('.ui-slider-handle').addClass('handle0')

      if filter_slider.parent().parent().is(':visible') && filter_slider.parent().parent().hasClass('used')
        if range == true
          filter_slider.slider('values', 0, $(this).parent().siblings('.filter_inputs').find('.min').val())
          filter_slider.slider('values', 1, $(this).parent().siblings('.filter_inputs').find('.max').val())
        else
          filter_slider.slider('value', $(this).parent().siblings('.filter_inputs').find('input').val())

    slide: (event, ui) ->
      inputs = filter_slider.parent().siblings('.filter_inputs').find('input')
      if range == true
        values = filter_slider.slider('values')
        inputs.map (index, item) ->
          $(item).val(values[index])
      else
        value = filter_slider.slider('value')
        inputs.val(value)

    stop: (event, ui) ->
      inputs = filter_slider.parent().siblings('.filter_inputs').find('input')
      if range == true
        values = filter_slider.slider('values')
        inputs.map (index, item) ->
          $(item).val(values[index])
      else
        value = filter_slider.slider('value')
        inputs.val(value)

filter_completion_handler = () ->
  $('.completion_input').each ->
    new MagicSuggest({
      data: $(this).data('source')
      emptyText: 'Введите название'
      maxSelectionRenderer: (v) ->
        "Вы не можете выбрать больше " + v + " вариантов"
      noSuggestionText: 'Ничего не найдено'
      renderTo: $(this)
      inputName: 'organization_ids[]'
      selectionPosition: 'right'
      useTabKey: true
      width: 280
      value: $(this).data('selected')
    })

filter_date_handler = () ->
  filter = $('.date_filter')
  $('ul li.selected input', filter).removeAttr('disabled')
  $('ul li a', filter).on 'click', ->
    $(this).parent().siblings().removeClass('selected').find('input').attr('disabled', 'disabled')
    $(this).parent().addClass('selected')
    $(this).siblings('input').removeAttr('disabled')
    false


@init_filter_handler = () ->
  set_previous_state()
  remove_filter_handler()
  criteria_handler()
  filter_slider_handler()
  filter_completion_handler()
  filter_date_handler()
  clear_form_handler()
  clear_filter_handler()
  initialize_map() if $('#geo', '.filters_wrapper').is(':visible')

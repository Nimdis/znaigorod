$.fn.get_object = ->
  form_data = this.serializeArray()
  form_object = {}
  $(form_data).each (i, item) ->
    form_object[item.name] = item.value
  form_object

$.fn.draw_map = (organization, context) ->
  longitude = organization[context+'[address_attributes][longitude]'] || '84.952222232222'
  latitude = organization[context+'[address_attributes][latitude]'] || '56.488611121111'
  container = this[0]
  point = new DG.GeoPoint(longitude, latitude)
  map = new DG.Map(container)
  marker = new DG.Markers.Common({ geoPoint: point })
  DG.autoload ->
    map.controls.add(new DG.Controls.Zoom())
  map.setCenter(point, 16)
  map.markers.add(marker)

update_coordinates = (organization, context) ->
  $.ajax '/yamp_geocoder',
    async:    false
    dataType: 'json'
    data:     'street='+organization[context+'[address_attributes][street]']+'&house='+organization[context+'[address_attributes][house]']
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(errorThrown)
    success: (data, textStatus, jqXHR) ->
      json = jQuery.parseJSON jqXHR.responseText
      if json.response_code == '500'
        alert "Cервис временно не доступен"
        return false
      organization[context+'[address_attributes][longitude]'] = json.longitude
      organization[context+'[address_attributes][latitude]']  = json.latitude
      $('#'+context+'_address_attributes_longitude').val(json.longitude)
      $('#'+context+'_address_attributes_latitude').val(json.latitude)
      if json.response_code == '404'
        alert "Координаты по указанному адресу не найдены!\nПожалуйста уточните адрес\nИли сохраняйте без указания координат"

$.fn.handler = (form, map_container, context) ->
  this.click ->
    organization = form.get_object()
    update_coordinates(organization, context)
    map_container.draw_map(organization, context)
    false

@init_organization_map = () ->
  form = $('.edit_organization, .new_organization')
  if form.length
    organization = form.get_object()
    map_container = $('#map')
    context = form.attr('id').replace(/(new|edit)_/, '').replace(/_\d+/, '')
    map_container.draw_map(organization, context)
    $('.get_coordinates').handler(form, map_container, context)

$ ->
  init_organization_map()

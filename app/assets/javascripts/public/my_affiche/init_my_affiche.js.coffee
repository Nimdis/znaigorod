@init_my_affiche = ->
  init_affiche_preview_title() if $('#affiche_title').length
  init_affiche_preview_description() if $('#affiche_description').length
  init_affiche_preview_tag() if $('#affiche_tag').length
  init_affiche_preview_video() if $('#affiche_trailer_code').length
  init_affiche_preview_map() if $('form.my_affiche_showings .my_affiche_map').length
  init_autosuggest_handler() if $('form.my_affiche_showings').length

  true

init_affiche_preview_title = ->
  $('#affiche_title').keyup ->
    if $(this).val()
      $('.my_affiche_wrapper .affiche_preview .title').html($(this).val())
    else
      $('.my_affiche_wrapper .affiche_preview .title').html('Нет названия')
    true
  $('#affiche_title').mouseup (event) ->
    setTimeout ->
      $('#affiche_title').keyup()
    , 1
    true
  $('#affiche_title').keyup()

  true

init_affiche_preview_description = ->
  $.extend mySettings,
    afterInsert: ->
      $('#affiche_description').keyup()
      true
  $('#affiche_description').markItUp(mySettings).keyup ->
    if $(this).val()
      $('.my_affiche_wrapper .affiche_preview .description .text').html(textile($(this).val()))
    else
      $('.my_affiche_wrapper .affiche_preview .description .text').html('Нет описания')
    true
  $('#affiche_description').mouseup (event) ->
    setTimeout ->
      $('#affiche_description').keyup()
    , 1
    true
  $('#affiche_description').keyup()

  true

init_affiche_preview_tag = ->
  $('#affiche_tag').tagit
    allowSpaces: true
    caseSensitive: false
    closeAutocompleteOnEnter: true
    singleFieldDelimiter: ', '
    autocomplete:
      delay: 0
      minLength: 1
      source: "#{$('#affiche_tag').closest('form').attr('action')}/available_tags"
  $('#affiche_tag').change ->
    if $(this).val().length
      $('.my_affiche_wrapper .affiche_preview .tags').html("Теги: #{$(this).val()}")
    else
      $('.my_affiche_wrapper .affiche_preview .tags').html('')
    true
  $('#affiche_tag').change()

  true

init_affiche_preview_video = ->
  $('#affiche_trailer_code').keyup ->
    $.ajax
      type: 'GET'
      url: "/my/affiches/#{$('#affiche_id').val()}/preview_video"
      data: $('#affiche_trailer_code').closest('form').serialize()
      success: (data, textStatus, jqXHR) ->
        $('.my_affiche_wrapper .affiche_preview .video').html(data)
        true
      error: (jqXHR, textStatus, errorThrown) ->
        wrapped = $("<div>#{jqXHR.responseText}</div>")
        wrapped.find('title').remove()
        wrapped.find('style').remove()
        wrapped.find('head').remove()
        console.error wrapped.html().stripTags().unescapeHTML().trim() if console && console.error
        true
    true

  $('#affiche_trailer_code').mouseup (event) ->
    setTimeout ->
      $('#affiche_trailer_code').keyup()
    , 1
    true
  $('#affiche_trailer_code').keyup()
  true

init_affiche_preview_map = ->
  ymaps.ready ->
    $form = $('form.my_affiche_showings')
    $map = $('.my_affiche_map', $form)

    latitude = $('.latitude', $form).val() || '56.5000000'
    longitude = $('.longitude', $form).val() || '84.9666700'

    map = new ymaps.Map $map[0],
      center: [latitude, longitude]
      zoom: 12
      behaviors: ['drag', 'scrollZoom']
    ,
      maxZoom: 23
      minZoom: 12

    map.controls.add 'zoomControl',
      top: 5
      left: 5

    if $('.latitude', $form).val() && $('.longitude', $form).val()
      affiche_placemark = create_placemark(latitude, longitude)
      map.geoObjects.add(affiche_placemark)
      map.setCenter([latitude, longitude])
      map.setZoom(16)

    map.events.add 'click', (event) ->
      coordinates = event.get('coordPosition')
      latitude = coordinates[0]
      longitude = coordinates[1]
      $('#showing_latitude').val(latitude)
      $('#showing_longitude').val(longitude)
      map.geoObjects.remove(affiche_placemark) if affiche_placemark?
      affiche_placemark = create_placemark(latitude, longitude)
      map.geoObjects.add(affiche_placemark)
      true

    $('#showing_place').on 'autocompleteselect', (event, ui) ->
      latitude = ui.item.latitude
      longitude = ui.item.longitude
      $('#showing_latitude').val(latitude)
      $('#showing_longitude').val(longitude)
      map.setCenter [latitude, longitude], 16,
        checkZoomRange: true
        duration: 800
        timingFunction: 'ease-in-out'
      map.geoObjects.remove(affiche_placemark) if affiche_placemark?
      affiche_placemark = create_placemark(latitude, longitude)
      map.geoObjects.add(affiche_placemark)

      true

    $('#showing_place').on 'autocompletesearch', (event, ui) ->
      $('#showing_organization_id').val('')
      true

  true

create_placemark = (latitude, longitude) ->
  affiche_placemark = new ymaps.GeoObject
    geometry:
      type: 'Point'
      coordinates: [latitude, longitude]
    properties:
      id: 'affiche_placemark'
  ,
    iconImageHref: '/assets/public/affiche_placemark.png'
    iconImageOffset: [-15, -40]
    iconImageSize: [37, 42]
    zIndex: 700

  affiche_placemark

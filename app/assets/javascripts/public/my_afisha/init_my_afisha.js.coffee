@init_my_afisha = ->
  init_afisha_preview_title() if $('#afisha_title').length
  init_afisha_preview_description() if $('#afisha_description').length
  init_afisha_preview_tag() if $('#afisha_tag').length
  init_afisha_preview_video() if $('#afisha_trailer_code').length
  init_afisha_preview_map() if $('form.my_afisha_showings .my_afisha_map').length
  init_autosuggest_handler() if $('form.my_afisha_showings').length
  init_afisha_help() if $('.help').length

  true

init_afisha_preview_title = ->
  $('#afisha_title').keyup ->
    if $(this).val()
      $('.my_afisha_wrapper .afisha_preview .title').html($(this).val())
    else
      $('.my_afisha_wrapper .afisha_preview .title').html('Нет названия')
    true
  $('#afisha_title').mouseup (event) ->
    setTimeout ->
      $('#afisha_title').keyup()
    , 1
    true
  $('#afisha_title').keyup()

  true

init_afisha_preview_description = ->
  $.extend mySettings,
    afterInsert: ->
      $('#afisha_description').keyup()
      true
  $('#afisha_description').markItUp(mySettings).keyup ->
    if $(this).val()
      $('.my_afisha_wrapper .afisha_preview .description .text').html(textile($(this).val()))
    else
      $('.my_afisha_wrapper .afisha_preview .description .text').html('Нет описания')
    true
  $('#afisha_description').mouseup (event) ->
    setTimeout ->
      $('#afisha_description').keyup()
    , 1
    true
  $('#afisha_description').keyup()

  true

init_afisha_preview_tag = ->
  $('#afisha_tag').tagit
    allowSpaces: true
    caseSensitive: false
    closeAutocompleteOnEnter: true
    singleFieldDelimiter: ', '
    autocomplete:
      delay: 0
      minLength: 1
      source: "#{$('#afisha_tag').closest('form').attr('action')}/available_tags"
  $('#afisha_tag').change ->
    if $(this).val().length
      $('.my_afisha_wrapper .afisha_preview .tags').html("Теги: #{$(this).val()}")
    else
      $('.my_afisha_wrapper .afisha_preview .tags').html('')
    true
  $('#afisha_tag').change()

  true

init_afisha_preview_video = ->
  $('#afisha_trailer_code').keyup ->
    $.ajax
      type: 'GET'
      url: "/my/afisha/#{$('#afisha_id').val()}/preview_video"
      data: $('#afisha_trailer_code').closest('form').serialize()
      success: (data, textStatus, jqXHR) ->
        $('.my_afisha_wrapper .afisha_preview .video').html(data)
        true
      error: (jqXHR, textStatus, errorThrown) ->
        wrapped = $("<div>#{jqXHR.responseText}</div>")
        wrapped.find('title').remove()
        wrapped.find('style').remove()
        wrapped.find('head').remove()
        console.error wrapped.html().stripTags().unescapeHTML().trim() if console && console.error
        true
    true

  $('#afisha_trailer_code').mouseup (event) ->
    setTimeout ->
      $('#afisha_trailer_code').keyup()
    , 1
    true
  $('#afisha_trailer_code').keyup()
  true

init_afisha_preview_map = ->
  ymaps.ready ->
    $form = $('form.my_afisha_showings')
    $map = $('.my_afisha_map', $form)

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
      afisha_placemark = create_placemark(latitude, longitude)
      map.geoObjects.add(afisha_placemark)
      map.setCenter([latitude, longitude])
      map.setZoom(16)

    map.events.add 'click', (event) ->
      coordinates = event.get('coordPosition')
      latitude = coordinates[0]
      longitude = coordinates[1]
      $('#showing_latitude').val(latitude)
      $('#showing_longitude').val(longitude)
      map.geoObjects.remove(afisha_placemark) if afisha_placemark?
      afisha_placemark = create_placemark(latitude, longitude)
      map.geoObjects.add(afisha_placemark)
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
      map.geoObjects.remove(afisha_placemark) if afisha_placemark?
      afisha_placemark = create_placemark(latitude, longitude)
      map.geoObjects.add(afisha_placemark)

      true

    $('#showing_place').on 'autocompletesearch', (event, ui) ->
      $('#showing_organization_id').val('')
      true

  true

create_placemark = (latitude, longitude) ->
  afisha_placemark = new ymaps.GeoObject
    geometry:
      type: 'Point'
      coordinates: [latitude, longitude]
    properties:
      id: 'afisha_placemark'
  ,
    iconImageHref: '/assets/public/afisha_placemark.png'
    iconImageOffset: [-15, -40]
    iconImageSize: [37, 42]
    zIndex: 700

  afisha_placemark

init_afisha_help = ->
  left = $('.show_help').position().left
  $('.help').css('left', left).prepend('<a class="close" title="закрыть" href="#">X</a>')
  $('.show_help').click ->
    $('.help').toggle()
    false
  $('.help .close').click ->
    $('.help').toggle()
    false

@init_my_affiche = ->
  init_affiche_preview_title() if $('#affiche_title').length
  init_affiche_preview_description() if $('#affiche_description').length
  init_affiche_preview_tag() if $('#affiche_tag').length
  init_affiche_preview_video() if $('#affiche_trailer_code').length
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
      data: "data=#{$('#affiche_trailer_code').val()}"
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

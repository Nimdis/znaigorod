@init_my_affiche = ->
  init_affiche_preview_title() if $('#affiche_title').length
  init_affiche_preview_description() if $('#affiche_description').length
  init_affiche_preview_tag() if $('#affiche_tag').length

  init_autosuggest_handler()
  true

init_affiche_preview_title = ->
  $('#affiche_title').keyup ->
    $('.my_affiche_wrapper .affiche_preview .title').html($(this).val())
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
    $('.my_affiche_wrapper .affiche_preview .description').html(textile($(this).val()))
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

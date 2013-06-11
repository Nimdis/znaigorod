@init_my_affiche = ->
  init_affiche_preview_title() if $('#affiche_title').length
  init_affiche_preview_description() if $('#affiche_description').length
  init_affiche_preview_tag() if $('#affiche_tag').length
  if $('form.my_affiche_showings').length
    init_autosuggest_handler()
    init_affiche_preview_showings()

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

init_affiche_preview_showings = ->
  preview_block = $('.my_affiche_wrapper .affiche_preview .showings')
  showings = $('.my_affiche_showings .fields')
  return true unless showings.length
  preview_list = $('<ul></ul>').appendTo(preview_block)
  showings.each (index, item) ->
    preview_item = $('<li></li>').appendTo(preview_list)
    place = $("<div class='place'>Место: <span></span></div>").appendTo(preview_item)
    $('span', place).text($("input[name*='place']", item).val())
    duration = $("<div class='duration'>Время: <span></span></div>").appendTo(preview_item)
    text = ''
    text += $("input[name*='starts_at']", item).val()
    text += ' – ' if text.length && $("input[name*='ends_at']", item).val()
    text += $("input[name*='ends_at']", item).val()
    $('span', duration).text(text)
    cost = $("<div class='cost'>Стоимость: <span></span></div>").appendTo(preview_item)
    text = ''
    text += $("input[name*='price_min']", item).val()
    text += ' – ' if text.length && $("input[name*='price_max']", item).val()
    text += $("input[name*='price_max']", item).val()
    $('span', cost).text(text)
    true

  true

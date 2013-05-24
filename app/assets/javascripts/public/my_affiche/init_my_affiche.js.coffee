@init_my_affiche = ->
  init_affiche_preview_title() if $('#affiche_title').length
  init_affiche_preview_description() if $('#affiche_description').length
  true

init_affiche_preview_title = ->
  $('#affiche_title').keyup ->
    $('.my_affiche_wrapper .affiche_preview .title').html($(this).val())
    true
  $('#affiche_title').keyup()
  true

init_affiche_preview_description = ->
  $('#affiche_description').markItUp(mySettings).keyup ->
    $('.my_affiche_wrapper .affiche_preview .description').html(textile($(this).val()))
    true
  $('#affiche_description').keyup()
  true

@init_my_affiche = () ->
  init_affiche_markitup() if $('#affiche_title, #affiche_description, #affiche_tag').length
  true

init_affiche_markitup = ->
  $('#affiche_description').markItUp(mySettings).keyup ->
    # TODO update preview this
    true
  $('#affiche_description').keyup()
  true

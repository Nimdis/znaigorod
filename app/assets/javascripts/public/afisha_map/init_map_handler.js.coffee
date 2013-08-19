@init_afisha_map = () ->
  $('.show_map_link').live 'click', (event) ->
    yaCounter14923525.reachGoal('affiche_address_click') if $(this).closest('.afisha').length && yaCounter14923525?
    init_modal_affiche_yandex_map $(this)
    false

  true

$ ->
  init_new_affiche() if $('.dropdown').length
  init_choose_file() if $('.choose_file').length
  init_datetime_picker()
  init_autosuggest_handler() if $('.autosuggest').length
  init_choose_coordinate() if $('.choose_coordinate').length
  init_vk_token() if $('.form_view.vk_token').length
  init_saunas() if $('#sauna_tabs').length
  init_has_virtual_tour() if $('.virtual_tour_fields')
  init_address() if $('.address_fields')
  init_services() if $('.services')

$(window).load ->
  init_organization_map() if $('.edit_organization, .new_organization').length

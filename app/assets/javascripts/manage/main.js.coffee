$ ->
  init_datetime_picker()

  init_new_affiche() if $('.dropdown').length
  init_choose_file() if $('.choose_file').length
  init_autosuggest_handler() if $('.autosuggest').length
  init_choose_coordinate() if $('.choose_coordinate').length
  init_vk_token() if $('.form_view.vk_token').length
  init_saunas() if $('#sauna_tabs').length
  init_menu_handler() if $('.input_with_image').length
  init_has_virtual_tour() if $('.virtual_tour_fields').length
  init_address() if $('.address_fields').length
  init_curtail() if $('.curtail').length
  init_discount_hidden() if $('#coupon_discount').length
  init_file_upload() if $('.file_upload').length
  init_ajax_delete() if $('.ajax_delete').length
  init_crop()
  init_webcam() if $('#webcam_snapshot_image').length

$(window).load ->
  init_organization_map() if $('.edit_organization, .new_organization').length

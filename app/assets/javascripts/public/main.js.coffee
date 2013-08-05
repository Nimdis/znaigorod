$ ->
  init_common()

  if typeof VK != 'undefined' && window.location.href.match(/http:\/\/znaigorod.ru/)
    init_vk_like() if $('#vk_like').length
    init_vk_recommended() if $('#vk_recommended').length
    init_vk_comments() if $('#vk_comments').length
    init_vk_organization_comments() if $('#vk_organization_comments').length
    init_vk_group_thin() if $('#vk_group_thin').length
    init_vk_group_thick() if $('#vk_group_thick').length
    init_vk_group_news() if $('#vk_group_news').length
    init_vk_group_subscribers() if $('#vk_group_subscribers').length

  init_main_page() if $('.main_page_affiche').length
  init_afisha_extend() if $('.content .affiche .photogallery')
  init_afisha_extend() if $('.content .affiche .trailer')
  init_afisha_filter() if $('.affiches_filter .periods .daily').length
  init_afisha_filter() if $('.navigation .periods .daily').length
  init_payment() if $('a.payment_link').length
  init_tabs() if $('.content .tabs').length
  init_poster() if $('.content .image a img, .organization_info .image a img').length
  init_distribution() if $('.content .distribution').length
  init_galleria() if $('.content .gallery_container').length
  init_coupon_colorbox() if $('.coupon .info .left_part a img').length
  init_menu_colorbox() if $('.menus .info .details a img').length
  init_filters_toggler() if $('.need_toggler li').length
  init_filter_handler() if $('.filters_wrapper').length
  init_contest() if $('.content_wrapper .contest').length
  init_prepare_organizations() if $('.organizations_list .info .characteristics').length
  init_organization_info() if $('.organization_info .info .description').length
  init_introduction() if $('.filters .introduction').length
  init_prepare_sauna() if $('.organization_info .sauna_hall_details').length
  init_iconize_info() if $('.organization_info .iconize_info li').length
  init_virtual_tour_link() if $('.organization_info .virtual_tour_link').length
  init_included_photos() if $('.affiche .photogallery li').length
  init_included_photos() if $('.organization_info .photogallery li').length
  init_included_photos() if $('.post .photogallery li').length
  init_post_photos() if $('.post a[rel="colorbox"]').length
  init_schedule_toggle() if $('.organization_info .more_schedule').length
  init_photogallery() if $('.content_wrapper .was_in_city_photos li').length
  init_pagination() if $('nav.pagination').length
  init_affiche_list_settings() if $('.content_wrapper .affiches_list .list_settings').length
  init_sms_claims() if $('.sms_claims li').length
  init_swfkrpano() if $('#krpano').length
  init_webcam_axis() if $('.webcams_list .webcam_axis').length
  init_webcam_uppod() if $('.webcams_list .webcam_uppod').length
  init_webcam_swf() if $('.webcams_list .webcam_swf').length
  init_webcam_mjpeg() if $('.webcams_list .webcam_mjpeg').length
  init_webcam_map() if $('.webcams .webcam_map').length
  init_stream_buro_service() if $('.lyube').length
  init_my_affiche() if $('.my_affiche_wrapper')
  init_datetime_picker()
  init_file_upload() if $('.file_upload').length
  init_ajax_delete() if $('.ajax_delete').length
  init_select_tags() if $('.select_tags').length
  init_messages() if $('.ajax_message_status').length
  init_change_friendship() if $('.change_friendship').length

  true

$(window).load ->
  init_comments() if $('.comments').length
  init_auth() if ('.auth_links').length
  init_rating() if ('.rating').length
  init_votes() if $('.votes_wrapper').length

  init_3dtourme_stat() if $('a.3dtourme').length
  init_prokachkov_stat() if $('a.prokachkov').length
  init_avtovokzal_tomsk_ru_stat() if $('a.avtovokzal_tomsk_ru').length
  init_dobrynin_stat() if $('a.dobrynin').length
  init_skoda_stat() if $('a.skoda').length
  init_peugeot_stat() if $('a.peugeot').length
  init_trodetfond_stat() if $('a.trodetfond').length
  init_tickets_stat() if $('.tickets_list li a.payment_link, .affiche .tickets a.payment_link').length

  init_afisha_yandex_map() if $('.yandex_map .map').length
  init_afisha_map() if $('.show_map_link').length
  init_comments() if $('.comments').length
  init_auth() if ('.auth_links').length
  init_services() if $('.services')
  init_menus() if $('.menus')

  init_move_to_top() if $('a.move_to_top').length
  init_crop()

  $('.disabled').on 'click',
    false

  true

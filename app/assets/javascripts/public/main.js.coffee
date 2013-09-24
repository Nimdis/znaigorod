$ ->
  init_common()
  init_preload_images()
  init_datetime_picker()

  if typeof VK != 'undefined'
    init_vk_like() if $('#vk_like').length
    init_vk_recommended() if $('#vk_recommended').length
    init_vk_comments() if $('#vk_comments').length
    init_vk_organization_comments() if $('#vk_organization_comments').length
    init_vk_group_thin() if $('#vk_group_thin').length
    init_vk_group_thick() if $('#vk_group_thick').length
    init_vk_group_news() if $('#vk_group_news').length
    init_vk_group_subscribers() if $('#vk_group_subscribers').length

  init_show_tipsy() if $('.show_tipsy') && $.fn.tipsy

  init_afisha_extend() if $('.afisha_show .photogallery')
  init_afisha_extend() if $('.afisha_show .trailer')
  init_afisha_filter() if $('.filters .by_date .daily').length
  init_social_actions() if $('.afisha_show').length
  init_social_actions() if $('.organization_show').length
  init_bets() if $('.afisha_show .auction').length
  init_bets_payment() if $('.account_show .bet_actions').length
  init_payment() if $('a.payment_link').length
  init_tabs() if $('.content .tabs').length
  init_poster() if $('.content .left .image a img').length
  init_distribution() if $('.content .distribution').length
  init_galleria() if $('.content .gallery_container').length
  init_cooperation() if $('.cooperation').length
  init_coupon_colorbox() if $('.coupon .info .left_part a img').length
  init_menu_colorbox() if $('.menus .info .details a img').length
  init_filters_toggler() if $('.need_toggler li').length
  init_filter_handler() if $('.filters_wrapper').length
  init_organization_jump_to_afisha() if $('.organization_show').length
  init_introduction() if $('.content .introduction').length
  init_more_categories_menu() if $('.filters .by_categories .more_link').length
  init_sauna_advanced_filter() if $('.filters_wrapper .advanced_filters_toggler').length
  init_sauna_halls_scroll() if $('.organizations_list .sauna_halls').length
  init_iconize_info() if $('.organization_show .show_description_link').length
  init_virtual_tour_link() if $('.organization_show .virtual_tour_link').length
  init_post_photos() if $('.post a[rel="colorbox"]').length
  init_schedule_toggle() if $('.organization_show .show_more_schedule').length
  init_photogallery() if $('.photogallery ul li').length
  init_back_to_top() if $('nav.pagination').length
  init_pagination() if $('nav.pagination').length
  init_visitors_pagination() if $('.content .left .social_actions .pagination').length
  init_account_pagination() if $('.content .account_show .right').length
  init_account_extend() if $('.account_show').length
  init_account_social_actions() if $('.account_show').length
  init_messages() if $('#messages_filter').length
  init_messages_tabs() if $('#messages_filter').length
  init_list_settings() if $('.content_wrapper .presentation_filters').length
  init_sms_claims() if $('.sms_claims li').length
  init_swfkrpano() if $('#krpano').length
  init_trailers() if $('.afisha_show .trailer p').length
  init_webcam_axis() if $('.webcams_list .webcam_axis').length
  init_webcam_jw() if $('.webcams_list .webcam_jw').length
  init_webcam_uppod() if $('.webcams_list .webcam_uppod').length
  init_webcam_swf() if $('.webcams_list .webcam_swf').length
  init_webcam_mjpeg() if $('.webcams_list .webcam_mjpeg').length
  init_webcam_map() if $('.webcams .webcam_map').length
  init_my_afisha() if $('.my_afisha_wrapper')
  init_file_upload() if $('.file_upload').length
  init_ajax_delete() if $('.ajax_delete').length
  init_select_tags() if $('.select_tags').length
  init_afisha_tabs() if $('#events_filter').length

  true

$(window).load ->
  init_comments() if $('.comments').length
  init_auth() if ('.auth_links').length
  init_votes() if $('.votes_wrapper').length
  init_votes() if $('.user_actions').length

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
  init_auth() if ('.auth_links').length
  init_services() if $('.services')
  init_menus() if $('.menus')

  init_move_to_top() if $('a.move_to_top').length
  init_crop()

  true

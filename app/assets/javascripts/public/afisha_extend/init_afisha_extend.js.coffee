@init_afisha_extend = () ->
  if window.location.hash == '#photogallery' && $.fn.scrollTo
    setTimeout ->
      $.scrollTo($('.afisha_show .photogallery'), 500, { offset: {top: -50} })
    , 300
  if window.location.hash == '#trailer' && $.fn.scrollTo
    setTimeout ->
      $.scrollTo($('.afisha_show .trailer'), 500, { offset: {top: -60} })
    , 300
  true

@init_afisha_tabs = () ->
  $('#events_filter').tabs()

@init_afisha_social_actions = () ->
  $('.social_actions').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    if $('.social_signin_links', $(response)).length
      $('.cloud_wrapper', target.closest('.social_actions')).remove()
      target.closest('.social_actions').append($(response))
      block = $('.cloud_wrapper', target.closest('.social_actions')).addClass('need_close_by_click')
      block.css
        left: target.position().left + target.outerWidth(true, true) + 9
        top: target.position().top + target.outerHeight(true, true) / 2 - block.outerHeight(true, true) / 2

      init_auth()

      return false

    if target.hasClass('change_visit')
      target = $(evt.target).closest('.social_actions')
      target.html(response)

    if target.hasClass('acts_as_inviter')
      container = $('<div class="inviter_form_wrapper" />').appendTo('body').hide().html(response)
      container.dialog
        autoOpen: true
        draggable: false
        modal: true
        resizable: false
        title: 'Хочу пригласить'
        width: '780px'

      $('.inviter_form_wrapper input:last').addClass('close_dialog')

      $('.inviter_form_wrapper .close_dialog').on 'click', ->
        $('.inviter_form_wrapper').dialog('close')

        $('.message_wrapper').replaceWith('<div class="message_wrapper">Приглашение успешно отправлено!</div>')
        $('.message_wrapper').delay(5000).slideUp 'slow'
      false

    if target.hasClass('acts_as_invited')
      target = $(evt.target).closest('.social_actions')
      target.html(jqXHR.responseText)

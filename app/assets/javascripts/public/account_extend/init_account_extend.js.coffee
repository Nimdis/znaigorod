@init_account_extend = () ->
  target = $('#account_avatar')
  target.on 'change', ->
    $(this).parents('form').submit()

    true

  target.hide()
  link = $('<a href="#">изменить фото</a>')
  target.closest('form').append(link)

  link.click ->
    target.click()

    false

@init_account_social_actions = () ->
  $('.account_show').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    if $('.social_signin_links', $(response)).length
      $('.cloud_wrapper', target.closest('.social_actions')).remove()

      signin_container = $('<div class="sign_in_with" />').appendTo('body').hide().html(response)
      signin_container.dialog
        autoOpen: true
        draggable: false
        modal: true
        resizable: false
        title: 'Необходима авторизация'
        width: '500px'

      init_auth()

      return false

    if target.hasClass('change_friendship')
      target.closest('li').replaceWith(response)

    if target.hasClass('add_private_message')
      container = $('<div class="private_message_form_wrapper" />').appendTo('body').hide().html(response)
      container.dialog
        autoOpen: true
        draggable: false
        modal: true
        resizable: false
        title: 'Новое сообщение'
        width: '500px'

      $('.private_message_form_wrapper .close').hide()
      $('.private_message_form_wrapper input:last').addClass('close_dialog')

      $('.private_message_form_wrapper .close_dialog').on 'click', ->
        $('.private_message_form_wrapper').dialog('close')

        $('.message_wrapper').replaceWith('<div class="message_wrapper">Сообщение успешно отправлено!</div>')
        $('.message_wrapper').delay(5000).slideUp 'slow'
      false

  true

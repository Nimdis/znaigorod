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

      $('.submit_dialog', form).click ->
        container.dialog('close')
        form = $('form', container)

        $('.message_wrapper')
          .replaceWith('<div class="message_wrapper">Приглашение успешно отправлено!</div>')
          .delay(5000)
          .slideUp('slow')

        false

    if target.hasClass('invite')
      invite_container = $('<div class="invite_message_form_wrapper" />').appendTo('body').hide().html(response)
      form = $('form', invite_container)
      invite_container.dialog
        autoOpen: true
        draggable: false
        modal: true
        resizable: false
        title: 'Приглашение'
        width: '500px'

      $('.submit_dialog', form).click ->
        invite_container.dialog('close')

        $('.message_wrapper')
          .replaceWith('<div class="message_wrapper">Приглашение успешно отправлено!</div>')
          .delay(5000)
          .slideUp('slow')

        false
  true

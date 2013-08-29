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

@init_social_actions = () ->
  $('.social_actions').on 'ajax:success', (evt, response, status, jqXHR) ->
    if $(evt.target).hasClass('change_friendship')
      $(evt.target).closest('li').replaceWith(response)

    if $(evt.target).hasClass('add_private_message')
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

      $('.private_message_form_wrapper .open_dialog').on 'click', ->
        account_id = parseInt($('#private_message_account_id').val())

        stored = JSON.parse(window.localStorage.getItem('dialogs')) || []
        stored.push(account_id) if stored.indexOf(account_id) < 0
        window.localStorage.setItem("dialogs", JSON.stringify(stored))

      false

  true

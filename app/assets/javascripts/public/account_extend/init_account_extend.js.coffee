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

    if target.hasClass('add_private_message') || target.hasClass('invite')
      container = $('<div class="message_form_wrapper" />').appendTo('body').hide().html(response)
      form = $('form', container)

      form.submit () ->
        $.ajax
          url: form.attr('action')
          type: 'POST'
          data: form.serialize()
          success: (response, textStatus, jqXHR) ->
            form.remove()
            true

        false

      container.dialog
        autoOpen: true
        draggable: false
        modal: true
        resizable: false
        title: 'Новое сообщение'
        width: '500px'
        close: (event, ui) ->
          form.submit()
          $(this).dialog('destroy')
          $(this).remove()
          true

      $('textarea', container).keyup ->
        if $(this).val()
          $('input[type=submit]', $(this).closest('form')).removeAttr('disabled').removeClass('disabled')
        else
          $('input[type=submit]', $(this).closest('form')).attr('disabled', 'disabled').addClass('disabled')
        true

      $('.submit_dialog', form).click ->
        container.dialog('close')

        $('.message_wrapper').text('Сообщение успешно отправлено!').show().delay(5000).slideUp('slow')

        false

  true

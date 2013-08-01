@init_messages = () ->
  $('.change_message_status').hide()

  $('.account_messages').on 'ajax:success', (evt, response) ->
    $(evt.target).closest('li').replaceWith(response)
    counter = $(response).data('counter')
    messages = $(response).data('messages')

    if counter == 0
      $('.messages a').addClass('empty').removeClass('new')
      $('.messages a').attr('title','Нет новых сообщений')
      $('.messages a').html(messages)
    else
      $('.messages a').addClass('new').removeClass('empty')
      $('.messages a').attr('title','Есть новые сообщения')
      $('.messages a').html(counter)

    $('.change_message_status').hide()

  $('.account_messages').on 'click', (evt) ->
    target = $(evt.target)
    if target.is('li')
      target.children('.change_message_status').click()

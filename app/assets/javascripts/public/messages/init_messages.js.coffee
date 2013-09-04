@process_change_message_status = () ->
  timer = setInterval ->
    target = $('a.change_message_status.unread:first')
    if target.length
      target.click()
      true
    else
      clearInterval(timer)
  , 1000

  true

@init_messages = () ->
  process_change_message_status()

  $('.account_messages').on 'ajax:success', (evt, response) ->
    $(evt.target).closest('li').replaceWith(response)
    counter = $(response).data('counter')
    notification_counter = $(response).data('notification_counter')
    messages = $(response).data('messages')

    wrapper = $('<div/>')
    wrapper.html(response)
    klass = $('li', wrapper).attr('class').replace('ajax_message_status', '').replace('unread', '').replace('read', '').compact()
    $("#notifications .#{klass}").removeClass('unread').addClass('read')
    wrapper.remove()

    link = $('.header .messages a')

    if counter == 0
      link.addClass('empty').removeClass('new').attr('title','Нет новых сообщений').html(messages)
    else
      link.addClass('unread').removeClass('empty').attr('title','Есть новые сообщения').html("+#{counter}")

    if notification_counter == 0
      $('#messages_filter a.notifications').html('Уведомления')
    else
      $('#messages_filter a.notifications').html("Уведомления +#{notification_counter}")

@init_messages_tabs = () ->
  $('#messages_filter').tabs()

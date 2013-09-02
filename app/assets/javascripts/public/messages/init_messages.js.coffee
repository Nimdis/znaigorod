@process_change_message_status = () ->
  timer = setInterval ->
    target = $('a.change_message_status.unread:first')
    if target.length
      target.click()
    else
      clearInterval(timer)
  , 1000

  true

@init_messages = () ->
  $('.change_message_status').hide()

  process_change_message_status()

  $('.account_messages').on 'ajax:success', (evt, response) ->
    $(evt.target).closest('li').replaceWith(response)
    counter = $(response).data('counter')
    messages = $(response).data('messages')

    wrapper = $('<div/>')
    wrapper.html(response)
    klass = $('li', wrapper).attr('class').replace('ajax_message_status', '').replace('unread', '').replace('read', '').compact()
    $("#notifications .#{klass}").removeClass('unread').addClass('read')
    wrapper.remove()

    if counter == 0
      $('.header .messages a').addClass('empty').removeClass('unread')
      $('.header .messages a').attr('title','Нет новых сообщений')
      $('.header .messages a').html(messages)
      $('#messages_filter .counter').html('')
    else
      $('.header .messages a').addClass('unread').removeClass('empty')
      $('.header .messages a').attr('title','Есть новые сообщения')
      $('.header .messages a').html("+#{counter}")
      $('#messages_filter .counter').html("(#{counter})")

    $('.change_message_status').hide()

@init_messages_tabs = () ->
  $('#messages_filter').tabs()

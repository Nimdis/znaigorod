@init_messages = () ->
  $('.change_message_status').hide()

  timer = setInterval ->
    target = $('a.change_message_status.new:first')
    if target.length
      target.click()
    else
      clearInterval(timer)
  , 1000

  $('.account_messages').on 'ajax:success', (evt, response) ->
    $(evt.target).closest('li').replaceWith(response)
    counter = $(response).data('counter')
    messages = $(response).data('messages')

    wrapper = $('<div/>')
    wrapper.html(response)
    klass = $('li', wrapper).attr('class').replace('ajax_message_status', '').replace('new', '').replace('read', '').compact()
    $("#notifications .#{klass}").removeClass('new').addClass('read')
    wrapper.remove()

    if counter == 0
      $('.header .messages a').addClass('empty').removeClass('new')
      $('.header .messages a').attr('title','Нет новых сообщений')
      $('.header .messages a').html(messages)
      $('#messages_filter .counter').html('')
    else
      $('.header .messages a').addClass('new').removeClass('empty')
      $('.header .messages a').attr('title','Есть новые сообщения')
      $('.header .messages a').html("+#{counter}")
      $('#messages_filter .counter').html("(#{counter})")

    $('.change_message_status').hide()

@init_messages_tabs = () ->
  $('#messages_filter').tabs()

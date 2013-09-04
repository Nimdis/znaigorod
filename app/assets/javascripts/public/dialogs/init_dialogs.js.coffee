@init_dialogs = () ->
  add_tab_handler = (response, stored) ->
    account = $(response).closest('ul.dialog').children('li:first').data('account')
    account_id = $(response).closest('ul.dialog').children('li:first').data('account_id')

    $('#messages_filter').tabs
      tabTemplate: "<li><a href='\#{href}\'><span class='with_close'>\#{label}\</span></a><span class='ui-icon ui-icon-close ui-corner-all close'>x</span></li>"
    $('#messages_filter').tabs "add", "#dialog_#{account_id}", "#{account}"
    $("#dialog_#{account_id}").append(response)
    $('#messages_filter').tabs "select", "#dialog_#{account_id}"

    stored.push(account_id) if stored.indexOf(account_id) < 0
    window.localStorage.setItem("dialogs", JSON.stringify(stored))

    scroll($('ul.dialog', "#dialog_#{account_id}"))

    timer = setInterval ->
      target = $('a.change_message_status.unread:first')
      if target.length
        target.click()
        true
      else
        clearInterval(timer)
    , 1000

    $("#dialog_#{account_id} a.change_message_status.unread").click ->
      link = $(this)

      $.ajax
        url: link.attr('href')
        type: 'PUT'
        data: '?_method=put'
        success: (response, textStatus, jqXHR) ->
          $('.change_message_status.unread:first').closest('li').replaceWith(response)
          counter = $(response).data('counter')
          notification_counter = $(response).data('notification_counter')
          dialog_counter = $(response).data('dialog_counter')
          messages = $(response).data('messages')

          link = $('.header .messages a')

          if counter == 0
            link.addClass('empty').removeClass('new').attr('title','Нет новых сообщений').html(messages)
          else
            link.addClass('unread').removeClass('empty').attr('title','Есть новые сообщения').html("+#{counter}")

          notification = $('#messages_filter a.notifications')
          if notification_counter == 0
            notification.html('Уведомления')
          else
            notification.html("Уведомления +#{notification_counter}")

          dialog = $('#messages_filter a.dialogs')
          if dialog_counter == 0
            dialog.html('Диалоги')
          else
            dialog.html("Диалоги +#{dialog_counter}")

        true

        error: (jqXHR, textStatus, errorThrown) ->
          wrapped = $("<div>#{jqXHR.responseText}</div>")
          wrapped.find('title').remove()
          wrapped.find('style').remove()
          wrapped.find('head').remove()
          console.error wrapped.html().stripTags().unescapeHTML().trim() if console && console.error
          true

      false

  close_tab_handler = (stored) ->
    close_buttons = $('#messages_filter span.ui-icon-close:not(.charged)')
    close_buttons.each (index, item) ->
      $(item).addClass('charged').live 'click', (evt) ->
        target = $(evt.target)

        dialog_id = $(target.siblings('a').attr('href'))
        account_id = target.siblings('a').attr('href').replace('#dialog_', '')
        link = target.siblings('a').attr('href').replace('#', '.')

        $("#dialogs #{link}").removeClass('disabled')

        dialog_id.remove()
        target.closest('li').remove()

        $('#messages_filter').tabs "select", "#dialogs"

        index = stored.indexOf(account_id)
        stored.splice(index, 1)
        window.localStorage.setItem("dialogs", JSON.stringify(stored))

        true
    true

  scroll = (target) ->
    y_coord = Math.abs(target[0].scrollHeight)
    target.animate({ scrollTop: y_coord }, 'fast')

  load_tabs_handler = (stored) ->
    stored.each (index) ->
      $("ul.dialogs a.dialog_#{index}").click()

  $.fn.submit_form = (response) ->
    account_id = $(response).closest('li').data('account_id')

    $('ul.dialog', "#dialog_#{account_id}").append(response)
    $('.private_message textarea').attr("value", "")
    scroll($('ul.dialog', "#dialog_#{account_id}"))


  stored = JSON.parse(window.localStorage.getItem('dialogs')) || []
  load_tabs_handler(stored)

  $('.to_dialog').on 'click', ->
    block_id = "##{$(this).attr('class').replace('to_dialog', '').replace('disabled', '').trim()}"
    $('#messages_filter').tabs("select", block_id)
    true

  $('.to_dialog').on 'ajax:beforeSend', (xhr, settings) ->
    return false if $(this).hasClass('disabled')
    true


  $('#messages_filter').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    if target.hasClass('to_dialog')
      $(evt.target).addClass('disabled')

      add_tab_handler(response, stored)
      close_tab_handler(stored)

    if target.hasClass('simple_form new_private_message')
      account_id = $(response).closest('li').data('account_id')

      $('ul.dialog', "#dialog_#{account_id}").append(response)
      $('.private_message textarea').attr("value", "")
      scroll($('ul.dialog', "#dialog_#{account_id}"))

    $('.private_message .close').on 'click', ->
      $('#messages_filter .ui-tabs-selected span.ui-icon-close').click()
      false
    true

  true


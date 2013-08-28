add_tab_handler = (response, stored) ->
  account = $(response).closest('ul.dialog').children('li:first').data('account')
  account_id = $(response).closest('ul.dialog').children('li:first').data('account_id')

  $('#messages_filter').tabs "add", "#dialog_#{account_id}", "#{account}"
  $("#messages_filter a[href='#dialog_#{account_id}']").after("<span class='ui-icon ui-icon-close ui-corner-all close'>x</span>")
  $("#dialog_#{account_id}").append(response)

  $('#messages_filter').tabs "select", "#dialog_#{account_id}"

  stored.push(account_id) if stored.indexOf(account_id) < 0
  window.localStorage.setItem("dialogs", JSON.stringify(stored))

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

load_tabs_handler = (stored) ->
  stored.each (index) ->
    $("ul.dialogs a.dialog_#{index}").click()

@init_dialogs = () ->
  stored = JSON.parse(window.localStorage.getItem('dialogs')) || []

  load_tabs_handler(stored)

  $('.to_dialog').on 'click', ->
    block_id = "##{$(this).attr('class').replace('to_dialog', '').replace('disabled', '').trim()}"
    $('#messages_filter').tabs("select", block_id)
    true

  $('.to_dialog').on 'ajax:beforeSend', (xhr, settings) ->
    return false if $(this).hasClass('disabled')

    true

  $('.to_dialog').on 'ajax:success', (evt, response) ->
    $(evt.target).addClass('disabled')

    add_tab_handler(response, stored)
    close_tab_handler(stored)

    $('.private_message .close').on 'click', ->
      $('#messages_filter .ui-tabs-selected span.ui-icon-close').click()
      false
    true

  true

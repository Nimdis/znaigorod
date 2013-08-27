@init_dialogs = () ->

  $('.to_dialog').live 'click', ->
    block_id = "##{$(this).attr('class').replace('to_dialog', '').replace('disabled', '').trim()}"
    $('#messages_filter').tabs("select", block_id)
    true

  $('.to_dialog').live 'ajax:beforeSend', (xhr, settings) ->
    return false if $(this).hasClass('disabled')

    true

  $('.to_dialog').on 'ajax:success', (evt, response) ->
    $(evt.target).addClass('disabled')

    account = $(response).closest('ul.dialog').children('li:first').data('account')
    account_id = $(response).closest('ul.dialog').children('li:first').data('account_id')

    $('#messages_filter').tabs "add", "#dialog_#{account_id}", "#{account}"
    $("#messages_filter a[href='#dialog_#{account_id}']").after("<span class='ui-icon ui-icon-close ui-corner-all close'>x</span>")
    $("#dialog_#{account_id}").append(response)

    $('#messages_filter').tabs "select", "#dialog_#{account_id}"

    $('#messages_filter span.ui-icon-close').live 'click', (evt) ->
      target = $(evt.target)

      dialog_id = $(target.siblings('a').attr('href'))
      link = target.siblings('a').attr('href').replace('#', '.')

      $("#dialogs #{link}").removeClass('disabled')

      dialog_id.remove()
      target.closest('li').remove()

      $('#messages_filter').tabs "select", "#dialogs"

      true

    true

  true

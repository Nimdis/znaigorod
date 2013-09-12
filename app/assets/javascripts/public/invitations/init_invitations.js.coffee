init_form_dialog = (title, target) ->
  dialog = $("<div'/>").dialog
    draggable: false
    height: 'auto'
    modal: true
    position: ['middle', 50]
    resizable: false
    title: title
    width: 'auto'
    close: (event, ui) ->
      $(this).dialog('destroy').remove()

  dialog.on 'ajax:success', (evt, response) ->
    if $(response).is('form')
      $(this).html(response)
    else
      $(this).dialog('destroy').remove()
      target.append(response).find('.empty').remove()

@init_invitations = ->
  $('.invitations_wrapper').on 'ajax:success', (evt, response) ->
    target = $(evt.target)

    init_form_dialog(target.data('title'), $(target.data('target'))).html(response) if target.hasClass('invitation_link')

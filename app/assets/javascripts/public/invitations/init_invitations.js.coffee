init_dialog = (selector, title) ->
  $("<div id='" + selector + "_dialog'/>").dialog
    draggable: false
    height: 'auto'
    modal: true
    position: ['middle', 50]
    resizable: false
    title: title
    width: 'auto'
    close: (event, ui) ->
      $(this).dialog('destroy')
      $(this).remove()

@init_invitations = ->
  $('.invitations_wrapper').on 'ajax:success', (evt, response) ->
    target = $(evt.target)

    if target.hasClass('invitation_link')
      dialog = init_dialog(target.attr('class'), target.data('title')).html(response)

      dialog.on 'ajax:success', (evt, response) ->
        if $(response).is('form')
          $(this).html(response)
        else
          console.log $(response)

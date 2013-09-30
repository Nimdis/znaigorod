@init_invitation_list_popup = ->
  not_answered_invitations = $('.not_answered_invitations')
  timestamp = $('li:first', not_answered_invitations).data('timestamp')

  is_closed = () ->
    unless (typeof(window.localStorage) == 'undefined')
      parseInt(window.localStorage.getItem('closed_at')) < (new Date).getTime()
    else
      false

  no_changes = () ->
    unless (typeof(window.localStorage) == 'undefined')
      parseInt(window.localStorage.getItem('closed_at'))/1000 > parseInt(timestamp)
    else
      false

  return if (is_closed() && no_changes()) || !not_answered_invitations.length

  dialog = init_form_dialog('not_answered_invitations', 'Новые приглашения', null, 650, 386).html(not_answered_invitations.show())

  dialog.on 'dialogclose', ->
    unless (typeof(window.localStorage) == 'undefined')
      window.localStorage.setItem('closed_at', (new Date).getTime())

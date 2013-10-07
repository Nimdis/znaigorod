@init_invitation_list_popup = ->
  not_answered_invitations = $('.not_answered_invitations')
  timestamp = $('li:first', not_answered_invitations).data('timestamp')

  is_closed = () ->
    unless (typeof(window.localStorage) == 'undefined')
      parseInt(window.localStorage.getItem('closed_at')) < (new Date).getTime()
    else
      false

  changed = () ->
    unless (typeof(window.localStorage) == 'undefined')
      parseInt(window.localStorage.getItem('closed_at'))/1000 < parseInt(timestamp)
    else
      false

  return if (is_closed() && !changed()) || !(not_answered_invitations.length && not_answered_invitations.find('li').length)
  return if $('.feature_wrapper').is(':visible')

  dialog = init_form_dialog('not_answered_invitations', 'Новые приглашения', null, 650, 386).html(not_answered_invitations.show())

  $('.to_dialog', dialog).remove()

  dialog.on 'dialogclose', ->
    unless (typeof(window.localStorage) == 'undefined')
      window.localStorage.setItem('closed_at', (new Date).getTime())

  dialog.on 'ajax:success', (evt, response) ->
    target = $(evt.target)
    if target.hasClass('agreement')
      invite_counter = $(response).data('invite_counter')
      target.closest('li').replaceWith(response)
      init_messages_counters(response)
      $('.to_dialog', dialog).remove()

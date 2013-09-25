init_form_dialog = (id, title, target, width = 300) ->
  dialog = $("<div class='" + id + "_form_dialog'/>").dialog
    draggable: false
    height: 'auto'
    modal: true
    position: ['center', 50]
    resizable: false
    title: title
    width: width
    close: (event, ui) ->
      $(this).dialog('destroy').remove()

  dialog.on 'ajax:success', (evt, response) ->
    if $(response).find('form').length
      $(this).html(response)
      init_gender_radio_buttons $('.left form', dialog)
    else
      $(this).dialog('destroy').remove()
      li = $(response)
      init_delete_invitation li
      target.append(li).find('.empty').remove()

  dialog

init_delete_invitation = (elem) ->
  elem.on 'ajax:success', (evt, response) ->
    target = $(evt.target)
    ul = target.parents('ul')
    target.parents('li').remove()

    unless ul.children().length
      ul.append('<li class="empty">Нет приглашений</li>')

init_gender_radio_buttons = (form) ->
  radio_buttons_block = $('div.radio_buttons', form)

  $('label', radio_buttons_block).each ->
    $(this).addClass($('input', this).attr('id'))
    $(this).addClass('checked') if $('input', this).is(':checked')
    $(this).click ->
      return false if $(this).hasClass('checked')

      $('label', radio_buttons_block).removeClass('checked')
      $(this).addClass('checked') if $('input', this).is(':checked')

@init_invitations = ->
  $('.invitations_wrapper').on 'ajax:success', (evt, response) ->
    target = $(evt.target)
    if target.hasClass('invitation_link')
      dialog = init_form_dialog('invitation', target.data('title'), $(target.data('target')), 650).html(response)

      init_gender_radio_buttons $('.left form', dialog)

  init_delete_invitation $('.delete_invitation')

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

  dialog

init_delete_invitation = (elem) ->
  elem.on 'ajax:success', (evt, response) ->
    target = $(evt.target)
    ul = target.parents('ul')
    target.parents('li').remove()

    unless ul.children().length
      ul.append('<li class="empty">Нет приглашений</li>')

handle_new_invitaion_link = (target, response) ->
  dialog = init_form_dialog('invitation', target.data('title'), $(target.data('target')), 650).html(response)

  handle_inviteables_search_close()
  $('#invitation_category').change ->
    category = encodeURIComponent($(this).val())
    link = $('.inviteables_search_open')
    href = link.attr('href').replace /category=(.*)/, "category=#{category}"
    link.attr('href', href)

    unless $('.inviteables_search_open').is(':visible')
      $('.inviteables_search_open').click()


  dialog.on 'ajax:success', (evt, response) ->
    #if $(response).find('form').length
      #$(this).html(response)

    if $(response).hasClass('inviteables_search_wrapper')
      $('.info').hide()
      $('.inviteables_search_open').hide()
      $('.inviteables_search_close').show()
      $('.inviteables_search_wrapper').replaceWith(response)


    #if $(response).is('li')
      #$(this).dialog('destroy').remove()
      #li = $(response)
      #init_delete_invitation li
      #target.parent().next('.list').find('ul').append(li).find('.empty').remove()

handle_inviteable_search = ->
  console.log 'search'

handle_inviteables_search_close = ->
  $('.inviteables_search_close').on 'click', ->
    $('.inviteables_search_close').hide()
    $('.inviteables_search_open').show()
    $('.info').show()
    $('.inviteables_search_wrapper').empty()

    false

@init_invitations = ->
  $('.invitations_wrapper').on 'ajax:success', (evt, response) ->
    target = $(evt.target)

    if target.hasClass('invitation_link')
      handle_new_invitaion_link(target, response)

    if target.hasClass('inviteables_search')
      handle_inviteable_search()

  init_delete_invitation $('.delete_invitation')

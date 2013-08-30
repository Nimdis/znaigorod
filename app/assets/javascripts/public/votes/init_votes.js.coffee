init_dialog = () ->
  $("<div class='liked_box'/>").dialog
    autoOpen: false
    draggable: false
    height: 'auto'
    modal: true
    position: ['middle', 50]
    resizable: false
    title: 'Понравилось'
    width: 'auto'

@init_votes = () ->
  init_dialog() unless $('.liked_box').length
  $('.votes_counter a').on 'ajax:success', (evt, response, status, jqXHR) ->
    $('.liked_box').dialog(
      open: (event, ui) ->
        $(event.target).html(jqXHR.responseText)
    ).dialog('open')

  init_dialog() unless $('.liked_box').length
  $('.like_box a').on 'ajax:success', (evt, response, status, jqXHR) ->
    $('.liked_box').dialog(
      open: (event, ui) ->
        $(event.target).html(jqXHR.responseText)
    ).dialog('open')

  links = $('.votes_wrapper .user_like a').not('.charged')
  link = links.addClass('charged').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target).closest('.votes_wrapper')
    $('.cloud_wrapper:visible').not(target.children('.cloud_wrapper')).hide()
    target.html(jqXHR.responseText)
    init_auth()
    cloud_handler()
    init_votes()

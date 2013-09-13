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
    close: (event, ui) ->
      $(this).dialog('destroy')
      $(this).remove()
      true

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

  $('.works').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    if $('.social_signin_links', $(response)).length
      $('.cloud_wrapper', target.closest('.social_actions')).remove()
      signin_container = $('<div class="sign_in_with" />').appendTo('body').hide().html(response)
      signin_container.dialog
        autoOpen: true
        draggable: false
        modal: true
        resizable: false
        title: 'Необходима авторизация'
        width: '500px'
        close: (event, ui) ->
          $(this).dialog('destroy')
          $(this).remove()
          true

      $('.like_wrapper', signin_container).remove()

      init_auth()

      return false

    if target.hasClass('change_vote')
      target.closest('.votes_wrapper').html(jqXHR.responseText)

    if target.hasClass('who_liked')
      init_dialog()

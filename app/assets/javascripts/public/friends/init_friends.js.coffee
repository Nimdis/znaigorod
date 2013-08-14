init_dialog = () ->
  $("<div class='buddies_box'/>").dialog
    autoOpen: false
    draggable: false
    height: 'auto'
    modal: true
    position: ['middle', 50]
    resizable: false
    title: 'Друзья'
    width: '300px'

@init_friends_list = () ->
  init_dialog() unless $('.friendors_box').length
  $('.friends_counter .floatr a').on 'ajax:success', (evt, response, status, jqXHR) ->
    $('.buddies_box').dialog(
      open: (event, ui) ->
        $(event.target).html(jqXHR.responseText)
    ).dialog('open')

  true

@init_change_friendship = () ->
  $('.change_friendship').on 'ajax:success', (evt, response) ->
    $(evt.target).closest('li').replaceWith(response)

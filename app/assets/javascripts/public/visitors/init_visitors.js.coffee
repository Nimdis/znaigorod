init_dialog = () ->
  $("<div class='visitors_box'/>").dialog
    autoOpen: false
    draggable: false
    height: 'auto'
    modal: true
    position: ['middle', 50]
    resizable: false
    title: 'Участники'
    width: 'auto'

@init_visitors = () ->
  init_dialog() unless $('.visitors_box').length
  $('.visits_counter a').on 'ajax:success', (evt, response, status, jqXHR) ->
    $('.visitors_box').dialog(
      open: (event, ui) ->
        $(event.target).html(jqXHR.responseText)
    ).dialog('open')

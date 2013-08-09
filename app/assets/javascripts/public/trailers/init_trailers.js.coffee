@init_trailers = () ->
  trailers = $('.afisha_show .trailer p')
  if trailers.length == 1
    $(trailers).css
      'float': 'none'
      'width': 760
      'height': 462
      'margin-right': 0
    $('iframe', trailers).css
      'width': 760
      'height': 462
    return true
  trailers.each ->
  $('.afisha_show .trailer p').each ->
    wrapper = $(this).css('position', 'relative')
    iframe = $('iframe', wrapper)
    overlay = $('<div />').prependTo(wrapper)
    overlay.css
      'position': 'absolute'
      'top': 0
      'left': 0
      'width': wrapper.width()
      'height': wrapper.height()
      'cursor': 'pointer'
    overlay.click ->
      trailer_dialog = $('<div class="trailer_dialog" />').appendTo('body').html(iframe.clone()).hide()
      trailer_dialog.css
        'text-align': 'center'
      $('iframe', trailer_dialog).css
        'width': 740
        'height': 450
        'margin': '0 auto'
      $(trailer_dialog).dialog
        width: 800
        height: 500
        modal: true
        resizable: false
        close: (event, ui) ->
          $(this).parent().remove()
          $(this).remove()
          true
      false
    true
  true

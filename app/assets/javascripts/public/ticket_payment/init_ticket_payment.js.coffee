@init_ticket_payment = () ->

  links = $('a.ticket_payment')


  links.each ->
    link = $(this)
    link.click ->
      $.ajax
        type: 'GET'
        url: link.attr('href')
        success: (data, textStatus, jqXHR) ->
          container = $('<div class="ticket_payment_form_wrapper" />').appendTo('body').hide().html(data)
          container.dialog
            width: 640
            height: 255
            title: 'Форма заказа билета'
            modal: true
            resizable: false
            open: ->
              $('input[type=submit]', $(this)).attr('disabled', 'disabled').addClass('disabled')
              $('#payment_phone', $(this)).inputmask 'mask',
                'mask': '+7-(999)-999-9999'
                'showMaskOnHover': false
            close: ->
              $(this).dialog('destroy')
              $(this).remove()
          true
        error: (jqXHR, textStatus, errorThrown) ->
          wrapped = $("<div>" + jqXHR.responseText + "</div>")
          wrapped.find('title').remove()
          wrapped.find('style').remove()
          wrapped.find('head').remove()
          console.error wrapped.html().stripTags().unescapeHTML().trim() if console && console.error
          true
      false
    true

  $('.ticket_payment_form_wrapper form').live 'submit', ->
    return false unless $('.ticket_payment_form_wrapper #payment_phone').inputmask('isComplete')

  $('.ticket_payment_form_wrapper #payment_phone').live 'keyup', ->
    if $(this).inputmask 'isComplete'
      $('input[type=submit]', $(this).closest('form')).removeAttr('disabled').removeClass('disabled')
    else
      $('input[type=submit]', $(this).closest('form')).attr('disabled', 'disabled').addClass('disabled')
    true

  true

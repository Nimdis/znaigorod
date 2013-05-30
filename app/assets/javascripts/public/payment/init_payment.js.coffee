@init_payment = () ->

  links = $('a.payment_link')

  links.each ->
    link = $(this)
    link.unbind('click').click ->
      $.ajax
        type: 'GET'
        url: link.attr('href')
        success: (data, textStatus, jqXHR) ->
          container = $('<div class="payment_form_wrapper" />').appendTo('body').hide().html(data)
          container.dialog
            width: 640
            title: 'Форма заказа'
            modal: true
            resizable: false
            open: ->
              $('input[type=submit]', $(this)).attr('disabled', 'disabled').addClass('disabled')
              $('#copy_payment_phone', $(this)).inputmask 'mask',
                'mask': '+7-(999)-999-9999'
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

  $('.payment_form_wrapper form').live 'submit', ->
    return false if $('.payment_form_wrapper .copies_with_seats input').length && !$('.payment_form_wrapper .copies_with_seats input:checked').length
    return false unless $('.payment_form_wrapper #copy_payment_phone').inputmask('isComplete')
    true

  $('.payment_form_wrapper #copy_payment_phone').live 'keyup', ->
    return false if $('.payment_form_wrapper .copies_with_seats input').length && !$('.payment_form_wrapper .copies_with_seats input:checked').length
    if $(this).inputmask 'isComplete'
      $('input[type=submit]', $(this).closest('form')).removeAttr('disabled').removeClass('disabled')
    else
      $('input[type=submit]', $(this).closest('form')).attr('disabled', 'disabled').addClass('disabled')
    true

  $('.payment_form_wrapper .copies_with_seats input').live 'change', ->
    unless $('.payment_form_wrapper .copies_with_seats input:checked').length
      $('input[type=submit]', $(this).closest('form')).attr('disabled', 'disabled').addClass('disabled')
      return false
    if $('.payment_form_wrapper #copy_payment_phone').inputmask 'isComplete'
      $('input[type=submit]', $(this).closest('form')).removeAttr('disabled').removeClass('disabled')
    else
      $('input[type=submit]', $(this).closest('form')).attr('disabled', 'disabled').addClass('disabled')
    true

  true

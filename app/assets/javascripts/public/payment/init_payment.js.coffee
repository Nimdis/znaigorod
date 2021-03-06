@init_payment = () ->

  $('a.payment_link').each ->
    link = $(this)
    link.click ->
      $.ajax
        type: 'GET'
        url: link.attr('href')
        success: (data, textStatus, jqXHR) ->
          container = $('<div class="payment_form_wrapper" />').appendTo('body').hide().html(data)
          title = 'Форма заказа'
          title = 'Оплата услуг' if $('#service_payment_details', container).length
          container.dialog
            width: 640
            title: title
            modal: true
            resizable: false
            create: (event, ui) ->
              $('body').css
                overflow: 'hidden'
              true
            beforeClose: (event, ui) ->
              $("body").css
                overflow: 'inherit'
            true
            open: ->
              init_actions_handler()
              true
            close: (event, ui) ->
              $(this).dialog('destroy')
              $(this).remove()
              true
          true

      false

    true

  if window.location.hash == '#buy_ticket'
    $('a.payment_link:first').click()

@init_actions_handler = ->

  $('.payment_form_wrapper form input[type=submit]').attr('disabled', 'disabled').addClass('disabled')

  $('.payment_form_wrapper form #copy_payment_phone').inputmask 'mask',
    'mask': '+7-(999)-999-9999'

  $('.payment_form_wrapper form input[type=submit]').click ->
    $('.payment_form_wrapper form').submit()
    false

  $('.payment_form_wrapper form').submit ->
    return false if $('.payment_form_wrapper .copies_with_seats input').length && !$('.payment_form_wrapper .copies_with_seats input:checked').length
    return false unless $('.payment_form_wrapper #copy_payment_phone').inputmask('isComplete')
    true

  $('.payment_form_wrapper #copy_payment_phone').keyup ->
    return false if $('.payment_form_wrapper .copies_with_seats input').length && !$('.payment_form_wrapper .copies_with_seats input:checked').length
    if $(this).inputmask 'isComplete'
      $('input[type=submit]', $(this).closest('form')).removeAttr('disabled').removeClass('disabled')
    else
      $('input[type=submit]', $(this).closest('form')).attr('disabled', 'disabled').addClass('disabled')
    true

  $('.payment_form_wrapper .copies_with_seats input').change ->
    unless $('.payment_form_wrapper .copies_with_seats input:checked').length
      $('input[type=submit]', $(this).closest('form')).attr('disabled', 'disabled').addClass('disabled')
      return false
    if $('.payment_form_wrapper #copy_payment_phone').inputmask 'isComplete'
      $('input[type=submit]', $(this).closest('form')).removeAttr('disabled').removeClass('disabled')
    else
      $('input[type=submit]', $(this).closest('form')).attr('disabled', 'disabled').addClass('disabled')
    true

  $('.payment_form_wrapper #service_payment_amount').keyup ->
    if $(this).val() && $('.payment_form_wrapper #service_payment_details').val()
      $('input[type=submit]', $(this).closest('form')).removeAttr('disabled').removeClass('disabled')
    else
      $('input[type=submit]', $(this).closest('form')).attr('disabled', 'disabled').addClass('disabled')
    true

  $('.payment_form_wrapper #service_payment_details').keyup ->
    if $(this).val() && $('.payment_form_wrapper #service_payment_amount').val()
      $('input[type=submit]', $(this).closest('form')).removeAttr('disabled').removeClass('disabled')
    else
      $('input[type=submit]', $(this).closest('form')).attr('disabled', 'disabled').addClass('disabled')
    true

  true

true

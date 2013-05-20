@init_sms_claims = () ->
  $('.sms_claims li a').each (index, element) ->
    link = $(this)
    link.click (event) ->
      return false if link.hasClass('busy')
      link.addClass('busy')
      $.ajax
        type: 'GET'
        url: link.attr('href')
        success: (data, textStatus, jqXHR) ->
          container = $('<div class="sms_claim_form_wrapper" />').appendTo('body').hide().html(data)
          container.dialog
            width: 640
            title: 'Бронирование услуги'
            modal: true
            resizable: false
            open: ->
              $('#sms_claim_name').focus()
              $('#sms_claim_phone').inputmask 'mask',
                'mask': '+7-(999)-999-9999'
              true
            close: ->
              $(this).dialog('destroy')
              $(this).remove()
              true
          link.removeClass('busy')
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
  $('.sms_claims li a:first').click()

  $('.sms_claim_form_wrapper form').live 'submit', (event) ->
    form = $(this)
    $('.submit input', form).attr('disabled', 'disabled').addClass('disabled')
    $.ajax
      type: 'POST'
      url: form.attr('action')
      data: form.serialize()
      success: (data, textStatus, jqXHR) ->
        if data.trim().startsWith('<form')
          $('.sms_claim_form_wrapper').html(data)
          $('#sms_claim_name').focus()
          $('#sms_claim_phone').inputmask 'mask',
            'mask': '+7-(999)-999-9999'
        else
          $('.sms_claim_form_wrapper').dialog('close')
          alert("Ваша заявка принята!\nСотрудник заведения свяжется с Вами.\nСпасибо за использования сервиса.")
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

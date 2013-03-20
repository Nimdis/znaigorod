@init_manipulate_contacts = () ->

  new_contact_link = $('.organization_show a.new_contact')
  new_contact_link.click (event) ->
    if $('.new_contact_form_wrapper', new_contact_link.closest('.right')).length
      $('.new_contact_form_wrapper form .actions .cancel', new_contact_link.closest('.right')).click()
      return  false
    $.ajax
      type: 'GET'
      url: new_contact_link.attr 'href'
      success: (data, textStatus, jqXHR) ->
        unless $('.new_contact_form_wrapper', new_contact_link.closest('.right')).length
          $('<div class=\'new_contact_form_wrapper\' />').insertAfter(new_contact_link.closest('h2'))
        new_contact_form_wrapper = $('.organization_show .new_contact_form_wrapper').hide()
        new_contact_form_wrapper.html(data)
        new_contact_form_wrapper.slideDown 'fast', ->
          $('form input:visible:first', new_contact_form_wrapper).focus()
          true
        true
    false

  $('.organization_show .new_contact_form_wrapper form').live 'submit', ->
    form = $(this)
    $.ajax
      type: 'POST',
      url: form.attr('action')
      data: form.serialize()
      success: (data, textStatus, jqXHR) ->
        if data.trim().startsWith('<div class=\'form_view\'>')
          form.closest('.new_contact_form_wrapper').html(data)
        if data.trim().startsWith('<ul class=\'contacts\'>')
          $('ul.contacts', form.closest('.right')).remove()
          form.closest('.right').append(data)
          $('.actions .cancel', form).click()
          $('ul.contacts li:first .name a', form.closest('.right')).click()
        true
    false

  $('.organization_show .new_contact_form_wrapper form .actions .cancel').live 'click', ->
    $('.organization_show .new_contact_form_wrapper').slideUp 'fast', ->
      $(this).remove()
      true
    false

  $('.organization_show .contacts .name a').live 'click', ->
    link = $(this)
    link.toggleClass('opened').toggleClass('closed')
    $('.details', link.closest('li')).slideToggle('fast')
    false

  $(document).ajaxError (event, jqXHR, ajaxSettings, thrownError) ->
    console.error jqXHR.responseText.stripTags().trim() if console && console.error
    true

  true

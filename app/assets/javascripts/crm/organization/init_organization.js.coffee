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

  $('.organization_show .contacts .info .name a').live 'click', ->
    link = $(this)
    link.toggleClass('opened').toggleClass('closed')
    $('.details', link.closest('li')).slideToggle('fast')
    false

  $('.organization_show .contacts .info .edit a').live 'click', ->
    link = $(this)
    $.ajax
      type: 'GET'
      url: link.attr('href')
      success: (data, textStatus, jqXHR) ->
        details = link.closest('.details').slideUp('fast')
        link.closest('.info').append(data)
        form = $('.form_view', link.closest('.info')).hide()
        form.slideDown 'fast', ->
          $('input:visible:first', form).focus().select()
        true
    false

  $('.organization_show .contacts .info .form_view .actions .cancel').live 'click', ->
    $('.form_view', $(this).closest('.info')).slideUp 'fast', ->
      $(this).remove()
      true
    $('.details', $(this).closest('.info')).slideDown('fast')
    false

  $('.organization_show .contacts .info .form_view form').live 'submit', ->
    form = $(this)
    edit_url = $('.details .edit a', form.closest('.info')).attr('href')
    $.ajax
      type: 'POST',
      url: form.attr('action')
      data: form.serialize()
      success: (data, textStatus, jqXHR) ->
        if data.trim().startsWith('<div class=\'form_view\'>')
          info = form.closest('.info')
          $('.form_view', info).remove()
          info.append(data)
        if data.trim().startsWith('<ul class=\'contacts\'>')
          right_block = form.closest('.right')
          $('ul.contacts', right_block).remove()
          right_block.append(data)
          info = $(".contacts .info .details a[href='#{edit_url}']", right_block).closest('.info')
          $('.name a', info).click()
        true

    false

  $(document).ajaxError (event, jqXHR, ajaxSettings, thrownError) ->
    console.error jqXHR.responseText.stripTags().trim() if console && console.error
    true

  true

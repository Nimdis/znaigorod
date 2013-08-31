@init_afisha_extend = () ->
  if window.location.hash == '#photogallery' && $.fn.scrollTo
    setTimeout ->
      $.scrollTo($('.afisha_show .photogallery'), 500, { offset: {top: -50} })
      true
    , 300
  if window.location.hash == '#trailer' && $.fn.scrollTo
    setTimeout ->
      $.scrollTo($('.afisha_show .trailer'), 500, { offset: {top: -60} })
      true
    , 300
  true

@init_afisha_tabs = () ->
  $('#events_filter').tabs()

@init_afisha_social_actions = () ->

  #$('.social_actions .acts_as_inviter').click()

  $('.social_actions').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    if $('.social_signin_links', $(response)).length
      $('.cloud_wrapper', target.closest('.social_actions')).remove()
      target.closest('.social_actions').append($(response))
      block = $('.cloud_wrapper', target.closest('.social_actions')).addClass('need_close_by_click')
      block.css
        left: target.position().left + target.outerWidth(true, true) + 9
        top: target.position().top + target.outerHeight(true, true) / 2 - block.outerHeight(true, true) / 2

      init_auth()

      return false

    if target.hasClass('change_visit')
      target = $(evt.target).closest('.social_actions')
      target.html(response)

    if target.hasClass('acts_as_inviter')
      container = $('<div class="inviter_form_wrapper" />').appendTo('body').hide().html(response)
      form = $('form', container)
      radio_buttons_block = $('.radio_buttons', form)

      $('label', radio_buttons_block).each ->
        $(this).addClass($('input', this).attr('id'))
        $(this).addClass('checked') if $('input', this).is(':checked')
        $(this).click ->
          return false if $(this).hasClass('checked')
          $('label', radio_buttons_block).removeClass('checked')
          $(this).addClass('checked') if $('input', this).is(':checked')
          true

        true

      $.fn.initialize_pagination = () ->
        page = 1
        busy = false
        next_link = $('nav.pagination .next a', container)
        list = $('.accounts_list', this)

        list.jScrollPane
          autoReinitialise: true
          verticalGutter: 0
          showArrows: true

        block_offset = $('li:last', list).outerHeight(true, true) * ($('li', list).length - 3) - $('.jspContainer', list).outerHeight(true, true)
        if next_link.length
          list.bind 'jsp-scroll-y', (event, scrollPositionY, isAtTop, isAtBottom) ->
            if block_offset < scrollPositionY && !busy
              busy = true
              page += 1
              $.ajax
                url: next_link.attr('href').replace(/page=\d+/, "page=#{page}")
                success: (response, textStatus, jqXHR) ->
                  return true if response.match(/empty_items_list/)
                  return true if response.trim().isBlank()
                  $('.jspPane', event.target).append(response)
                  busy = false
                  block_offset = $('li:last', event.target).outerHeight(true, true) * ($('li', event.target).length - 3) - $('.jspContainer', list).outerHeight(true, true)
                  true

            true
        true

      $.fn.initialize_filter = () ->
        $('.filter a', this).each ->
          $(this).on 'click', ->
            false
          true
        true

      container.dialog
        autoOpen: true
        draggable: false
        modal: true
        resizable: false
        title: 'Хочу пригласить'
        width: 780
        open: (event, ui) ->

          block = $('.right', this)

          block.initialize_pagination()
          block.initialize_filter()

          true

        close: (event, ui) ->
          $(this).dialog('destroy')
          $(this).remove()

          true

      $('.submit_dialog', form).click ->
        container.dialog('close')

        $('.message_wrapper')
          .replaceWith('<div class="message_wrapper">Приглашение успешно отправлено!</div>')
          .delay(5000)
          .slideUp('slow')

        false

    if target.hasClass('acts_as_invited')
      target = $(evt.target).closest('.social_actions')
      target.html(jqXHR.responseText)

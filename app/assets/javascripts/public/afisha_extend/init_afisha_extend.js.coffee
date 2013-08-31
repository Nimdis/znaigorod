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

      $('label', radio_buttons_block).each (index, item) ->
        $(item).addClass($('input', item).attr('id'))
        $(item).addClass('checked') if $('input', item).is(':checked')
        $(item).click ->
          return false if $(this).hasClass('checked')
          $('label', radio_buttons_block).removeClass('checked')
          $(this).addClass('checked') if $('input', this).is(':checked')
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
          console.log 'open'
          console.log this
          console.log $('.accounts_list', this)
          $('.accounts_list', this).jScrollPane
            verticalGutter: 0
            showArrows: true
          .bind 'jsp-scroll-y', (event, scrollPositionY, isAtTop, isAtBottom) ->
            #console.log event
            #console.log isAtTop
            #console.log isAtBottom
            true

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

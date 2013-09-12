@init_social_actions = () ->
  social_actions = $('.social_actions')
  social_actions.on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    if $('.social_signin_links', $(response)).length
      $('.cloud_wrapper', target.closest('.social_actions')).remove()
      signin_container = $('<div class="sign_in_with" />').appendTo('body').hide().html(response)
      signin_container.dialog
        autoOpen: true
        draggable: false
        modal: true
        resizable: false
        title: 'Необходима авторизация'
        width: '500px'
        close: (event, ui) ->
          $(this).dialog('destroy')
          $(this).remove()
          true

      init_auth()

      return false

    if target.hasClass('change_visit')
      visit = $(response).closest('li')
      target.closest('li').replaceWith(visit)

      visitors = $(response).closest('.list')
      $('<div class="list"/>').appendTo(social_actions) unless $('.list', social_actions).length
      $('.social_actions .list').replaceWith(visitors)

    if target.hasClass('acts_as_inviter') || target.hasClass('acts_as_invited')

      $.fn.initialize_invite = () ->
        list = $('.accounts_list', this)
        $('li .details form', list).unbind('submit').submit ->
          invite_form = $(this)
          $.ajax
            type: 'POST'
            url: invite_form.attr('action')
            data: invite_form.serialize()
            success: (response, textStatus, jqXHR) ->
              invite_form.after('<span class="sended">Приглашен</span>').remove() if target.hasClass('acts_as_inviter')
              invite_form.after('<span class="sended">Запрос отправлен</span>').remove() if target.hasClass('acts_as_invited')
              true
          false

        true

      $.fn.initialize_pagination = () ->
        page = 1
        busy = false
        list = $('.accounts_list', this)
        pagination = $('.pagination', this)
        next_link = $('.next a', pagination)

        list.jScrollPane
          autoReinitialise: true
          verticalGutter: 0
          showArrows: true
          mouseWheelSpeed: 30

        block_offset = $('li:last', list).outerHeight(true, true) * ($('li', list).length - 3) - $('.jspContainer', list).outerHeight(true, true)
        if next_link.length
          list.bind 'jsp-scroll-y', (event, scrollPositionY, isAtTop, isAtBottom) ->
            if block_offset < scrollPositionY && !busy
              busy = true
              $.ajax
                url: next_link.attr('href')
                success: (response, textStatus, jqXHR) ->
                  return true if response.match(/empty_items_list/)
                  return true if response.trim().isBlank()
                  wrapped = $("<div>#{response}</div>")
                  $('.jspPane', event.target).append($('.accounts_list li', wrapped))
                  pagination.html($('.pagination', wrapped).html())
                  next_link = $('.next a', pagination)
                  block_offset = $('li:last', event.target).outerHeight(true, true) * ($('li', event.target).length - 3) - $('.jspContainer', list).outerHeight(true, true)
                  busy = false
                  true

            true
        true

      $.fn.initialize_filter = () ->
        block = $(this)
        $('.filter a', block).each ->
          $(this).click ->
            link_wrapper = $(this).closest('li')
            return false if link_wrapper.hasClass('selected')
            $.ajax
              url: $(this).attr('href')
              success: (response, textStatus, jqXHR) ->
                wrapped = $("<div>#{response}</div>")
                $('.accounts_list', block).remove()
                $('.accounts_list', wrapped).appendTo(block)
                $('.pagination', block).remove()
                $('.pagination', wrapped).appendTo(block)
                link_wrapper.siblings().removeClass('selected')
                link_wrapper.addClass('selected')
                $('#q', block).val('')
                block.initialize_pagination()
                block.initialize_invite()
                true

            false

          true

        true

      $.fn.initialize_search = () ->
        block = $(this)
        $('.search_form form', block).on 'submit', ->
          form = $(this)
          return false unless $('#q', block).val()
          $.ajax
            url: form.attr('action')
            data: form.serialize()
            success: (response, textStatus, jqXHR) ->
              wrapped = $("<div>#{response}</div>")
              $('.accounts_list', block).remove()
              $('.accounts_list', wrapped).appendTo(block)
              $('.pagination', block).remove()
              $('.pagination', wrapped).appendTo(block)
              $('.filter li', block).removeClass('selected')
              block.initialize_pagination()
              block.initialize_invite()
              true

          false

        true

      container = $('<div class="invite_form_wrapper" />').appendTo('body').hide().html(response)

      container.dialog
        autoOpen: true
        draggable: false
        modal: true
        resizable: false
        title: $('h2', container).text()
        width: 780
        create: (event, ui) ->
          $('body').css
            overflow: 'hidden'
          true
        open: (event, ui) ->
          block = $('.right', this)
          block.initialize_pagination()
          block.initialize_filter()
          block.initialize_search()
          block.initialize_invite()
          true
        beforeClose: (event, ui) ->
          $("body").css
            overflow: 'inherit'
          true
        close: (event, ui) ->
          $(this).dialog('destroy')
          $(this).remove()
          true

      left_form = $('.left form', container)
      radio_buttons_block = $('.radio_buttons', left_form)

      $('label', radio_buttons_block).each ->
        $(this).addClass($('input', this).attr('id'))
        $(this).addClass('checked') if $('input', this).is(':checked')
        $(this).click ->
          return false if $(this).hasClass('checked')
          $('label', radio_buttons_block).removeClass('checked')
          $(this).addClass('checked') if $('input', this).is(':checked')
          true

        true

      left_form.each ->
        $form = $(this)
        $form.submit ->
          $.ajax
            url: $form.attr('action')
            type: 'POST'
            data: $form.serialize()
            success: (response, textStatus, jqXHR) ->
              target.closest('.social_actions').html(response)
              container.dialog('close')
              unless $('.message_wrapper').length
                $('body').prepend('<div class=\'message_wrapper\'>')
              if $('.radio_buttons', $form).length
                $('.message_wrapper').text('Приглашение успешно отправлено!')
              else
                $('.message_wrapper').text('Приглашение удалено!')
              $('.message_wrapper').show().delay(5000).slideUp('slow')
              true

          false

        true

    if target.hasClass('new_inviter_message')
      target.after('<span class="sended">Приглашен</span>').remove()

    if target.hasClass('new_invited_message')
      target.after('<span class="sended">Запрос отправлен</span>').remove()

  recalculate_block_height = (kind, limit = 0) ->
    prev_element_top = $('li:first', kind).position().top
    block_height = $('li:first', kind).outerHeight(true, true)
    $('ul li', kind).each (index) ->
      if $(this).position().top > prev_element_top
        prev_element_top = $(this).position().top
        block_height += $(this).outerHeight(true, true)
      return false if limit > 0 && (limit - 1) == index
      true

    block_height

  scroll = (target) ->
    y_coord = Math.abs($(window).height() - target.offset().top - 200)
    $("html, body").animate({ scrollTop: y_coord })

    true

  $('.left .afisha_avatars .next_page').live 'ajax:beforeSend', (xhr, settings) ->
    return false if $(this).hasClass('disabled')
    true

  $('.left .afisha_avatars .next_page').live 'ajax:success', (event, response, status, xhr) ->

    more_handler = (kind, response) ->
      unless $('li.delimiter', kind).length
        $('li:last', kind).addClass('delimiter')

      kind.css('height', recalculate_block_height(kind))
      wrapped = $("<div>#{response}</div>")
      $('ul', kind).append($('ul', wrapped).html())
      $('.pagination:last', kind).hide()
      $('.pagination', kind).after($('.pagination', wrapped))
      wrapped.remove()
      kind.animate
        height: recalculate_block_height(kind)
        , 300, ->
          $('.pagination:first', kind).remove()
          $('.pagination:last', kind).show()
          scroll($('.pagination', kind))
          true

      true

    list = $(event.target).closest('.list')
    if list.length
      more_handler(list, response)

  $('.left .afisha_avatars .pagination .toggler').live 'click', (event) ->
    return false if $(this).hasClass('disabled')

    collapse_handler = (kind) ->

      delimiter_index = $('li.delimiter', kind).index()

      min_height = recalculate_block_height(kind, delimiter_index + 1)

      kind.animate
        height: min_height
        , 300, ->
          $('ul li', kind).each (index) ->
            $(this).remove() if index > delimiter_index
            true
          replaced_href = $('.next_page', kind).attr('href').replace(/page=\d+/, 'page=2')
          $('.next_page', kind).attr('href', replaced_href).removeClass('disabled')
          $('.toggler', kind).addClass('disabled')
          scroll($('.pagination', kind))
          true

      false

    list = $(event.target).closest('.list')
    if list.height
      collapse_handler(list)

    false

  true

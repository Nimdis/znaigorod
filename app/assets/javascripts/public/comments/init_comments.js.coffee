@init_comments = () ->

  cancel_handler = () ->
    $('.cancel', '.comments').on 'click', ->
      remove_comment_form()
      show_link()
      false

  show_link = () ->
    $('.new_answer:hidden, .new_comment:hidden', '.comments').show()

  remove_comment_form = () ->
    remove_highlight()
    show_link()
    $('.ajaxed_item', '.comments').remove()

  scroll = () ->
    target = $('.ajaxed_item', '.comments')
    y_coord = Math.abs($(window).height() - target.offset().top - target.height()) + 150
    $("html, body").animate({ scrollTop: y_coord })

  remove_highlight = () ->
    $('.active', '.comments').removeClass('active')
    false

  $.fn.new_comment = (response) ->
    remove_comment_form()
    $(this).hide().siblings('ul').append(response)
    scroll()
    $(this).siblings('ul').trigger('added_form')

  $.fn.new_answer = (response) ->
    remove_comment_form()
    $(this).hide().closest('.comment_wrapper').addClass('active').siblings('ul').append(response)
    scroll()
    $(this).closest('.comment_item').trigger('added_form')

  $.fn.submit_form = (response) ->
    $(this).closest('.ajaxed_item').replaceWith(response)
    if !$(response).find('form').length
      remove_highlight()
      show_link()

  restore_comment = () ->
    unless (typeof(window.localStorage) == 'undefined')
      id = window.localStorage.getItem('comment_id')
      body = window.localStorage.getItem('comment_body')
      if id
        if id.match(/new_comment/)
          link = $('.new_comment')
          link.click()
          target = link.siblings('ul')
          target.on 'added_form', ->
            target.find('li.comment_form textarea').val(body)
            target.off 'added_form'
        else
          target = $('#'+id)
          $('.new_answer:first', target).click()
          target.on 'added_form', ->
            target.children('ul').find('li.comment_form textarea').val(body)
            target.off 'added_form'

        window.localStorage.clear()

  $(".ajaxed").on "ajax:success", (evt, response, status, jqXHR) ->
    target = $(evt.target)

    if $('.social_signin_links', $(response)).length
      $('.cloud_wrapper', target.closest('.social_actions')).remove()

      wrapped = $("<div>#{response}</div>")
      $('img.avatar', wrapped).remove()
      $('span.profile_link', wrapped).remove()
      $('form.new_comment', wrapped).remove()
      $('h4', wrapped).remove()
      $('p:first', wrapped).css('text-align', 'center')
      wrapped = $('li.ajaxed_item', wrapped).html()

      signin_container = $('<div class="sign_in_with" />').appendTo('body').hide().html(wrapped)
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

    switch target.attr('class')
      when 'new_comment' then target.new_comment(jqXHR.responseText)
      when 'new_answer'  then target.new_answer(jqXHR.responseText)
      else target.submit_form(jqXHR.responseText)

    cancel_handler()
    init_auth()

  restore_comment()

  true

cancel_handler = () ->
  $('.cancel').on 'click', ->
    link = $(this)
    if link.hasClass('new_record')
      link.closest('ul').siblings('.new_comment').show()
      link.closest('ul').siblings('.comment_wrapper').css('background', '#ffffff').find('.new_record').show()
      link.closest('.ajaxed_item').remove()
    false

@init_comments = () ->
  $(".ajaxed").on "ajax:success", (evt, response, status, jqXHR) ->
    target = $(evt.target)
    ul = target.siblings("ul")

    if target.hasClass('new_record')
      if ul.length
        ul.append(jqXHR.responseText)
      else
        window.scrollTo 0, target.closest('.comment_wrapper').css('background', '#eef4f7').siblings('ul').append(jqXHR.responseText).offset().top

      if target.hasClass('new_comment')
        $('form.new_comment .cancel').click()
        target.hide()
    else
      target.closest('ul').siblings('.comment_wrapper').css('background', '#fff').find('.new_comment').show() unless $(jqXHR.responseText).find('.error').length
      target.closest('.ajaxed_item').replaceWith(jqXHR.responseText)

    cancel_handler()

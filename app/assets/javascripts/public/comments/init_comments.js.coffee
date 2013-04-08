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
  y_coord = Math.abs($(window).height() - target.offset().top - target.height())
  $("html, body").animate({ scrollTop: y_coord})

remove_highlight = () ->
  $('.active', '.comments').removeClass('active')
  false

$.fn.new_comment = (response) ->
  remove_comment_form()
  $(this).hide().siblings('ul').append(response)
  scroll()

$.fn.new_answer = (response) ->
  remove_comment_form()
  $(this).hide().closest('.comment_wrapper').addClass('active').siblings('ul').append(response)
  scroll()

$.fn.submit_form = (response) ->
  $(this).closest('.ajaxed_item').replaceWith(response)
  remove_highlight()
  show_link()

@init_comments = () ->
  $(".ajaxed").on "ajax:success", (evt, response, status, jqXHR) ->
    target = $(evt.target)

    switch target.attr('class')
      when 'new_comment' then target.new_comment(jqXHR.responseText)
      when 'new_answer'  then target.new_answer(jqXHR.responseText)
      else target.submit_form(jqXHR.responseText)

    cancel_handler()

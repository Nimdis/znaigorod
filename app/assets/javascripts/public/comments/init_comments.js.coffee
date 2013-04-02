$.fn.show_loader_for = (content) ->
  target = $(this)
  target.addClass('show_loader')
  setTimeout ->
    target.removeClass('show_loader').html(content)
  ,
    800
  target

cancel_handler = () ->
  $('.cancel').on 'click', ->
    link = $(this)
    if link.hasClass('new_record')
      link.closest('ul').siblings('.new_comment').show()
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
        parent = target.closest('.ajaxed')
        parent.show_loader_for(jqXHR.responseText)

      if target.hasClass('new_comment')
        $('form.new_comment .cancel').click()
        target.hide()
    else
      target.closest('ul').siblings('.new_comment').show() unless $(jqXHR.responseText).find('.error').length
      target.closest('.ajaxed_item').replaceWith(jqXHR.responseText)

    cancel_handler()

    if $('.remove_file').length
      remove_link = $('.remove_file')
      upload_link = $('<a href="#" class="choose_file">Выбрать файл</a>').hide()
      remove_link.after(upload_link)

      remove_file(
        remove_link.parent('.add_file_wrapper'),
        remove_link.siblings('.input').children('input'),
        upload_link
      )

    init_choose_file() if $('.choose_file').length


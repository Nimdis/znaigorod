@init_menu_handler = () ->
  $('.input_with_image').each ->
    $('a.remove', $(this)).click ->
      $(this).prev('img').remove()
      delete_image_name = $('input', $(this).next('.hidden')).attr('name').replace('[image]', '[delete_image]')
      $(this).parent().append("<input type='checkbox' name='#{delete_image_name}' checked='checked' class='hidden' />")
      $(this).next('.hidden').removeClass('hidden').val(null)
      $(this).remove()
      false
    true
  true

@init_ajax_delete = () ->
  $('.ajax_delete:not(.armed)').addClass('armed').on 'ajax:success', (evt, data) ->
    $(evt.target).closest('li').replaceWith(data)

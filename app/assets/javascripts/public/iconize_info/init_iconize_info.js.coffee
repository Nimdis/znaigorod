@init_iconize_info = () ->
  block = $('.organization_show .show_description_link')
  block.each (index, item) ->
    $(this).click ->
      title = $(this).siblings('.title').text() + '. Описание'
      description = $(this).siblings('.description').html()
      container = $('<div class="tags_wrapper" />').appendTo('body').hide().html(description)
      container.dialog
        width: 500
        title: title
        modal: true
        resizable: false
        close: ->
          $(this).dialog('destroy')
          $(this).remove()
          true

      false
    true
  true

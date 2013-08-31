@init_iconize_info = () ->
  block = $('.organization_show .show_description_link')
  block.each (index, item) ->
    $(this).click ->
      dialog_max_height = $(window).innerHeight() * 90 /100
      dialog_width = 600
      title = $(this).siblings('.title').text() + '. Описание'
      description = $(this).siblings('.description').html()
      container = $('<div class="suborganization_information_wrapper" />').appendTo('body').html(description).hide()
      container.show().css
        'width': dialog_width
      container_height = container.outerHeight(true, true)
      if container_height > dialog_max_height
        dialog_height = dialog_max_height
      else
        dialog_height = 'auto'
      container.dialog
        width: dialog_width
        height: dialog_height
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

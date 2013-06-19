@init_select_tags = () ->

  $('.select_tags').on 'ajax:complete', (event, jqXHR) ->
    container = $('<div class="tags_wrapper" />').appendTo('body').hide().html('')
    dialog_height = $(window).innerHeight() * 90 /100

    container.dialog
      height: dialog_height
      width: 850
      title: 'Форма заказа'
      modal: true
      resizable: false

      open: ->
        $(this).html(jqXHR.responseText)
        selected_tags = $('.tagit-label').map (index, span) -> $(span).text()

        $.makeArray(selected_tags).each (tag, index) ->
          $('input[value="' + tag + '"]').attr('checked', 'checked')

      close: ->
        $(this).dialog('destroy')
        $(this).remove()
    true


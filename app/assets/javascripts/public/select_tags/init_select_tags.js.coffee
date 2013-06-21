@init_select_tags = () ->

  $('.select_tags').on 'ajax:complete', (event, jqXHR) ->
    container = $('<div class="tags_wrapper" />').appendTo('body').hide().html(jqXHR.responseText)
    dialog_height = $(window).innerHeight() * 90 /100

    container.dialog
      height: dialog_height
      width: 850
      title: 'Форма заказа'
      modal: true
      resizable: false

      open: ->
        selected_tags = $.makeArray($('.tagit-label').map (index, span) -> $(span).text())

        selected_tags.each (tag, index) ->
          $('input[value="' + tag + '"]').attr('checked', 'checked')

        $('.submit', container).click ->
          tags = $.makeArray($('input:checked').map (index, input) -> $(input).attr('value'))
          $('#affiche_tag').tagit('removeAll')
          tags.each (tag, index) ->
            $('#affiche_tag').tagit('createTag', tag)

          container.dialog('close')

      close: ->
        $(this).dialog('destroy')
        $(this).remove()
    true

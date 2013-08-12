@init_change_friendship = () ->
  $('.change_friendship').on 'ajax:success', (evt, response) ->
    $(evt.target).closest('li').replaceWith(response)

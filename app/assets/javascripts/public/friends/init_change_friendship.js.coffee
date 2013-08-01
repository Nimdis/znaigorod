@init_change_friendship = () ->
  $('.change_friendship').on 'ajax:success', (evt, response) ->
    $(evt.target).replaceWith(response)

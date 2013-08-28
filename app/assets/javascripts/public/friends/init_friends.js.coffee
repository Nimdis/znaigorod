@init_change_friendship = () ->
  $('.social_actions').on 'ajax:success', (evt, response) ->
    $(evt.target).closest('li').replaceWith(response)

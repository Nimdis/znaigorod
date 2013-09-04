@init_bets = () ->
  $('.auction').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)
    target.siblings('ul').append(response)

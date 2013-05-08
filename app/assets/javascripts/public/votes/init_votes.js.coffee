@init_votes = () ->
  init_visitors()
  links = $('.votes_wrapper .user_like a').not('.charged')
  link = links.addClass('charged').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target).closest('.votes_wrapper')
    $('.cloud_wrapper:visible').not(target.children('.cloud_wrapper')).hide()
    target.html(jqXHR.responseText)
    init_auth()
    cloud_handler()
    init_votes()

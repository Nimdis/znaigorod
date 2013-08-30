@init_organization_social_actions = () ->

  $('.social_actions').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    if $('.social_signin_links', $(response)).length
      $('.cloud_wrapper', target.closest('.social_actions')).remove()
      target.closest('.social_actions').append($(response))
      block = $('.cloud_wrapper', target.closest('.social_actions')).addClass('need_close_by_click')
      block.css
        left: target.position().left + target.outerWidth(true, true) + 9
        top: target.position().top + target.outerHeight(true, true) / 2 - block.outerHeight(true, true) / 2

      return false

  true

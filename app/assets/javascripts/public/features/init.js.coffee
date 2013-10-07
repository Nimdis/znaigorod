@init_features = () ->
  invites_feature = $('.new_feature .invites_feature')
  overlay = $('.new_feature_overlay')
  top_headline = $('.top_headline')
  slide_up = $('.slide_up', invites_feature)

  is_closed = () ->
    unless (typeof(window.localStorage) == 'undefined')
      parseInt(window.localStorage.getItem('invite_feature_closed_at')) < (new Date).getTime()
    else
      false

  slide_up.on 'click', ->
    invites_feature.slideUp()
    overlay.fadeOut()
    $('body').css('overflow', 'auto')
    unless (typeof(window.localStorage) == 'undefined')
      window.localStorage.setItem('invite_feature_closed_at', (new Date).getTime())

  top_headline.on 'click', ->
    $('body').css('overflow', 'hidden')
    overlay.fadeIn()
    invites_feature.slideDown()

  $('.invitation_link').on 'click', ->
    slide_up.click()

  top_headline.click() unless is_closed()

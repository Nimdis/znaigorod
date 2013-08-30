init_handlers = () ->
  $('.rating .user_rating .star_wrapper div').on
    mouseenter: ->
      $(' .user_rating .star_wrapper .active').removeClass('active').addClass('inactive')
      $(this).add($(this).prevAll('div')).addClass('hover')

    mouseleave: ->
      $('.user_rating .star_wrapper .inactive').removeClass('inactive').addClass('active')
      $(this).add($(this).prevAll('div')).removeClass('hover')

  $('.rating .user_rating .star_wrapper div').on 'click', ->
    $(this).siblings().removeClass('active')
    $(this).addClass('selected').add($(this).prevAll('div')).addClass('active')
    $('#user_rating_value_'+parseInt($(this).attr('class').replace('star_',''))).attr('checked', 'checked').closest('form').submit()

init_state = () ->
  init_auth()
  selected = $('.user_rating .star_'+$('.rating form input:checked').val())
  selected.addClass('selected').add(selected.prevAll('div')).addClass('active')
  cloud_handler()

@cloud_handler = () ->
  if $('.cloud_wrapper:visible').length
    $(document).on 'keydown', (e) ->
      return false if $('.cloud_wrapper').closest('.comment_form').length
      if e.keyCode == 27
        $('.cloud_wrapper').remove()

    $(document).on 'click', ->
      return false if $('.cloud_wrapper').closest('.comment_form').length
      $('.cloud_wrapper').remove()

restore_rating = () ->
  unless (typeof(window.localStorage) == 'undefined')
    rating = window.localStorage.getItem('rating')
    if rating
      $('.user_rating .'+rating).trigger('click')
      window.localStorage.clear()

@init_rating = () ->
  init_handlers()
  init_state()
  restore_rating()

  $(".rating").on "ajax:success", (evt, response, status, jqXHR) ->
    $(evt.target).closest('.rating').html(jqXHR.responseText)
    init_handlers()
    init_state()

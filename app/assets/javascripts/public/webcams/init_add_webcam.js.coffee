@init_add_webcam = () ->

  $('.webcams .add_webcam').click ->
    introduction = $('.instruction', $(this).closest('.webcams'))
    introduction.toggle()
    introduction.addClass('need_close_by_click') unless introduction.hasClass('need_close_by_click')
    false

  true

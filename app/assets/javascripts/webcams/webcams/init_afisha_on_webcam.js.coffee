@init_afisha_on_webcam = () ->
  $('.webcams .tickets .redirect_to_afisha').click ->
    return true if $(this).closest('.content_wrapper').length
    window.opener.location.href = $(this).attr('href')
    self.close()
    false

  true

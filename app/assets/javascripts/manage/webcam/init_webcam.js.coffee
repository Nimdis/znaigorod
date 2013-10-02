@init_webcam = () ->

  $('#webcam_snapshot_image').on 'change', ->
    $(this).parents('form').submit()
    true

  true

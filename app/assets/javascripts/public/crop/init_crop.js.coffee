@init_crop = () ->
  crop_x = $('[id*="crop_x"]').val()
  crop_y = $('[id*="crop_y"]').val()
  crop_width = $('[id*="crop_width"]').val()
  crop_height = $('[id*="crop_height"]').val()

  $('.jcrop').Jcrop
    setSelect:   [ crop_x, crop_y, crop_x + crop_width, crop_y + crop_height ]
    aspectRatio: 290 / 390
    onChange: (coords) ->
      crop_x = $('[id*="crop_x"]').val(coords.x)
      crop_y = $('[id*="crop_y"]').val(coords.y)
      crop_width = $('[id*="crop_width"]').val(coords.w)
      crop_height = $('[id*="crop_height"]').val(coords.h)

  $('#affiche_poster_image').on 'change', ->
    $(this).parents('form').trigger 'submit'

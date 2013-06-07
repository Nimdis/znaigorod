@init_crop = () ->
  crop_x = $('[id*="crop_x"]').val()
  crop_y = $('[id*="crop_y"]').val()
  crop_width = $('[id*="crop_width"]').val()
  crop_height = $('[id*="crop_height"]').val()

  $('.jcrop').Jcrop
    setSelect: [ crop_x, crop_y, crop_x + crop_width, crop_y + crop_height ]
    aspectRatio: 290 / 390
    onChange: (coords) ->
      update_crop(coords)
      crop_x = $('[id*="crop_x"]').val(coords.x)
      crop_y = $('[id*="crop_y"]').val(coords.y)
      crop_width = $('[id*="crop_width"]').val(coords.w)
      crop_height = $('[id*="crop_height"]').val(coords.h)
      true

  $('#affiche_poster_image').on 'change', ->
    $(this).parents('form').trigger 'submit'
    true

  true

update_crop = (coords) ->
  rx = 150/coords.w
  ry = 200/coords.h
  preview = $('.affiche_preview .poster img')

  preview.css
    width: Math.round(rx * preview.attr('width')) + 'px'
    height: Math.round(ry * preview.attr('height')) + 'px'
    marginLeft: '-' + Math.round(rx * coords.x) + 'px'
    marginTop: '-' + Math.round(ry * coords.y) + 'px'

  true

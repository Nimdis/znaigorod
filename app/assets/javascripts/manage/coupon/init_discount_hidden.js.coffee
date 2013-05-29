@init_discount_hidden = () ->
  $('#coupon_price_without_discount').keyup ->
    if $(this).val().length
      $('#coupon_discount').closest('.input').slideUp('fast')
    else
      $('#coupon_discount').closest('.input').slideDown('fast')
    true
  $('#coupon_price_without_discount').keyup()

  true

@init_account_extend = () ->
  $('#account_avatar').on 'change', ->
    $(this).parents('form').submit()

    true

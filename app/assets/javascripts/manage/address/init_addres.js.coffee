@init_address = () ->
  add_link = $('.add_address')
  remove_link = $('.remove_address')

  $('.address_fields').on 'nested:fieldAdded', ->
    $('.fields:first', $(this)).remove()
    add_link.hide()
    remove_link.show()
    init_organization_map()

  $('.address_fields').on 'nested:fieldRemoved', ->
    add_link.show()
    remove_link.hide()

  add_link.hide()

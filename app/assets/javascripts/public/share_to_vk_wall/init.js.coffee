@init_share_to_vk_wall = (owner_id, message, attachments) ->
  VK.init({apiId: 3556288})
  VK.Api.call('wall.post', { owner_id: owner_id, message: message, attachments: attachments }, (r) ->
    r
    VK.init({apiId: 3136085})
  )

@share_on_click = (target) ->
  $this = $(target)
  return unless $this.data('owner_id')
  additional_message = $this.closest('form').find($this.data('additinal_message')).val()
  insert_to_message = $($this.data('insert_to_message')).parent().text()
  message = $this.data('message').replace(/%text%/, insert_to_message.toLocaleLowerCase())
  text = message
  text += '\n' + additional_message if additional_message && additional_message.length
  init_share_to_vk_wall($this.data('owner_id'), text, $this.data('attachments'))

@init_share_to_vk_wall = (owner_id, message, attachments) ->
  VK.init({apiId: 3556288})
  VK.Api.call('wall.post', { owner_id: owner_id, message: message, attachments: attachments }, (r) ->
    r
    VK.init({apiId: 3136085})
  )

@share_on_click = (target) ->
  $this = $(target)
  return unless $this.data('owner_id')
  message = $this.data('message')
  init_share_to_vk_wall($this.data('owner_id'), message, $this.data('attachments'))

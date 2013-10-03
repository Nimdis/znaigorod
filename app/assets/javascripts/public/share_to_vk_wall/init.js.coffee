@init_share_to_vk_wall = (owner_id, message, attachments) ->
  VK.init({apiId: 3556288})
  VK.Api.call('wall.post', { owner_id: owner_id, message: message, attachments: attachments }, (r) ->
    r
    VK.init({apiId: 3136085})
  )

@share_on_click = (target) ->
  $this = $(target)
  return unless $this.data('owner_id')

  if $this.data('message')?
    message = $this.data('message') || ''
  else
    action = $this.data('action') || ''
    gender = $this.data('gender') || ''
    category = $this.data('category') || ''

    if $this.data('inviteable_title')
      title = $this.data('inviteable_title') || ''
      preposition = $this.data('preposition') || ''
      message = "#{action} #{gender} #{preposition} \"#{title}\""
    else
      message = "#{action} #{gender} #{category}"

  if $this.data('attachments')?
    attachments = $this.data('attachments')
  else
    poster = $this.data('poster')
    link = $this.data('link')
    attachments = "#{poster},#{link}"

  init_share_to_vk_wall($this.data('owner_id'), message, attachments)

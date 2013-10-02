$ ->

  if typeof VK != 'undefined'
    init_vk_like() if $('#vk_like').length

  init_webcam_axis()  if $('.webcam_show .webcam_axis').length
  init_webcam_jw()    if $('.webcam_show .webcam_jw').length
  init_webcam_uppod() if $('.webcam_show .webcam_uppod').length
  init_webcam_swf()   if $('.webcam_show .webcam_swf').length

  true

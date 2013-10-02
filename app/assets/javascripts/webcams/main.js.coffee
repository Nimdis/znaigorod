$ ->

  if typeof VK != 'undefined'
    init_vk_like() if $('#vk_like').length

  init_webcam_axis() if $('.webcams_list .webcam_axis').length
  init_webcam_jw() if $('.webcams_list .webcam_jw').length
  init_webcam_uppod() if $('.webcams_list .webcam_uppod').length
  init_webcam_swf() if $('.webcams_list .webcam_swf').length
  init_webcam_mjpeg() if $('.webcams_list .webcam_mjpeg').length
  init_webcam_map() if $('.webcams .webcam_map').length

  true

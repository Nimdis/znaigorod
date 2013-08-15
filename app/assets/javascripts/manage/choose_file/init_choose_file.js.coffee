@init_choose_file = () ->
  links = $('.choose_file')
  remove_link = $('.remove_link')

  remove_link.live 'click', ->
    $this = $(this)
    $('#'+$this.siblings('a').attr('class').replace('choose_file', '')).val('')
    $this.siblings('div').html('')
    $this.hide()
    $this.siblings('a').show()
    false

  links.live 'click', ->
    $this = $(this)
    params = $this.attr('params')
    target_id = $this.attr('class').replace('choose_file', '')
    target = $('#'+target_id)
    choose_file_wrapper = $this.parent('div')
    uploaded_file_wrapper = $this.siblings('div')
    type = uploaded_file_wrapper.attr('class').replace('uploaded_file_wrapper', '')

    dialog = $this.create_or_return_dialog('elfinder_picture_dialog')
    dialog.attr('id_data', target_id)
    dialog.load_iframe(params)

    target.change ->
      file_url = target.val()

      if type.match(/image/)
        uploaded_file_wrapper.html('<img src="'+file_url+'"/>')
      else
        uploaded_file_wrapper.html('<a href="'+file_url+'">'+file_url+'</a>')
      remove_link.show()
      $this.hide()
      target.unbind('change')

    false
